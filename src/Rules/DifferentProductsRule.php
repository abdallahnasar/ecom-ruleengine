<?php

namespace Abdallah\EcomRuleEngine\Rules;


class DifferentProductsRule implements RuleInterface
{
    /**
     * @param array $condition
     * @return string
     */
    public function generate(array $condition): string
    {
        return '$cart->getCartSize() ' . $condition['operator'] . ' ' . $condition['value'];
    }
}
