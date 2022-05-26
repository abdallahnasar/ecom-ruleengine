<?php


use Abdallah\EcomRuleEngine\Http\Controllers\HomeController;

Route::get('/rule-engine',[HomeController::class, 'index']);

Route::post('validate', [HomeController::class, 'validateRules']);
