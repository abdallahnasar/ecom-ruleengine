<?php

namespace Abdallah\EcomRuleEngine\Rules;

class QuantityRule implements RuleInterface
{
    /**
     * @param array $condition
     * @return string
     */
    public function generate(array $condition): string
    {
        return '$cart->searchItemByQuantity(' . $condition['value'] . ') ';
    }
}
