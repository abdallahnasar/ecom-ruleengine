<?php

namespace Abdallah\EcomRuleEngine\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Abdallah\EcomRuleEngine\Entities\Cart;
use Abdallah\EcomRuleEngine\Services\RuleEngine;

class HomeController extends Controller
{
    public function index()
    {
        return view('ruleEngine::rule-engine');
    }

    public function validateRules(Request $request,RuleEngine $ruleEngine, Cart $cart): array
    {

        // TODO: add request validation classes to validate data of cart and items
        $data = $request->all();
        $cart->create($data);
        return $ruleEngine->validateCart($cart);
    }
}
