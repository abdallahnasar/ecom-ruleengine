<?php

namespace Abdallah\EcomRuleEngine\Rules;

class TotalQuantityRule implements RuleInterface
{
    /**
     * @param array $condition
     * @return string
     */
    public function generate(array $condition): string
    {
        return '$cart->getTotal() ' . $condition['operator'] . ' ' . $condition['value'];
    }
}
