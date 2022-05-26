<?php

namespace Abdallah\EcomRuleEngine\Rules;

class RepeatingCustomerRule implements RuleInterface
{
    /**
     * @param array $condition
     * @return string
     */
    public function generate(array $condition): string
    {
        // todo when applying login and register add below rule after adding hasPreviousOrders which checks
        // if no of previous orders of current user is above specific number
        //$ruleConditions .= 'auth()->user()->hasPreviousOrders() ' . $operator . ' ' . $condition['value'];
        return '$cart->getRepeatingCustomer() ' . $condition['operator'] . ' ' . $condition['value'];

    }
}
