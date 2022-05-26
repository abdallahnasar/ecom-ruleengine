<?php

namespace Abdallah\EcomRuleEngine\Rules;

class NeverOrderedRule implements RuleInterface
{
    /**
     * @param array $condition
     * @return string
     */
    public function generate(array $condition): string
    {
        return '$cart->getNeverOrdered() ' . $condition['operator'] . ' ' . $condition['value'];
    }
}
