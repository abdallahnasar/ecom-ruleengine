<?php

namespace Abdallah\EcomRuleEngine\Rules;

class PromoCodeRule implements RuleInterface
{
    /**
     * @param array $condition
     * @return string
     */
    public function generate(array $condition): string
    {
        return '$cart->getPromoCode()' . $condition['operator'] . ' \'' . $condition['value'] . '\'';
    }
}
