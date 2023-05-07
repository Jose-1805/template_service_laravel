<?php

namespace App\Traits;

use Illuminate\Support\Facades\Validator;

trait FormRequestToValidator
{
    public function formRequestToValidator(string $form_request_class, array $data)
    {
        $request = new ($form_request_class)();
        return Validator::make($data, $request->rules(), $request->messages(), $request->attributes());
    }
}
