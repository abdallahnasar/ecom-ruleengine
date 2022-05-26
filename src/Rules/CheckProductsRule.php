<?php

namespace Abdallah\EcomRuleEngine\Rules;

class CheckProductsRule implements RuleInterface
{
    /**
     * @param array $condition
     * @return string
     */
    public function generate(array $condition): string
    {
        $ruleConditions = '';
        $productsToCheck = explode('/', $condition['name']);
        foreach ($productsToCheck as $product) {
            $ruleConditions .= '$cart->searchItemByName(\'' . $product . '\') || ';
        }
        return '('.substr($ruleConditions, 0, -4).')';
    }
}
