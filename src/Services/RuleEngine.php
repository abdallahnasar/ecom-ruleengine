<?php

namespace Abdallah\EcomRuleEngine\Services;

use Abdallah\EcomRuleEngine\Entities\Cart;
use Abdallah\EcomRuleEngine\GenerateConditionCheckProducts;
use Abdallah\EcomRuleEngine\Helpers\Helper;
use Abdallah\EcomRuleEngine\Rules\CheckProductsRule;
use Symfony\Component\Yaml\Yaml;

class RuleEngine
{
    public array $rules;

    /**
     * @return array
     */
    public function getRules(): array
    {
        return $this->rules;
    }

    /**
     * RuleEngine constructor set rules from config when initiating
     */
    public function __construct()
    {
        $config = config('rule-engine');
        $typeToCheck = [
//            'json' => json_decode(file_get_contents(public_path($config['path'])), true),
            'json' => json_decode(file_get_contents(__DIR__.'/../../../../../public/'.$config['path']), true),
//            'yaml' => Yaml::parseFile(public_path($config['path'])),
            //TODO: use maatwebsite/excel to get data from excel sheet
            //'xls' => 'read from xls',
        ];
        $allRules = $typeToCheck[$config['type']];
        foreach ($allRules as $rule) {
            $this->addRule($rule['conditions'], $rule['action'], $rule['conditions_operator'] ?? null);
        }

    }

    /**
     * @param array $conditions
     * @param array $action
     * @param string|null $conditionsOperator
     */
    public function addRule(array $conditions, array $action, ?string $conditionsOperator)
    {
        $conditionString = $this->addMultipleRuleConditions($conditions, $conditionsOperator);
        //TODO: set rule to entity class with condition and action attributes instead of array
        $this->rules[] = ['condition' => $conditionString, 'action' => $action];
    }

    /**
     * @param array $conditions
     * @param string|null $conditionsOperator
     * @return string
     */
    public function addMultipleRuleConditions(array $conditions, ?string $conditionsOperator): string
    {
        $ruleConditions = '';
        foreach ($conditions as $condition) {

            if (str_contains($condition['name'], '/')) {
                $conditionObject = new CheckProductsRule;
            }else{
                $className = Helper::underscoresToPascalCase($condition['name']);
                $classDir = 'Abdallah\\EcomRuleEngine\\Rules\\' . $className . 'Rule';
                $conditionObject = new $classDir();
            }
            $ruleConditions .= $conditionObject->generate($condition);


            if ($conditionsOperator) {
                $ruleConditions .= ' ' . $conditionsOperator . ' ';
            }
        }

        if (!$conditionsOperator) {
            return $ruleConditions;
        }

        return substr($ruleConditions, 0, -4);

    }

    /**
     * @param Cart $cart
     * @return string[]
     */
    public function validateCart(Cart $cart): array
    {

        foreach ($this->rules as $rule) {
            $ruleCondition = eval('return ' . $rule['condition'] . ';');
            if ($ruleCondition) {
                return $rule['action'];
            }
        }
        return ['string' => 'no actions'];
    }


}
