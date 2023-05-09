<?php

namespace App\Traits;

use Illuminate\Support\Facades\Validator;

trait FormRequestToValidator
{
    /**
     * Crea una instancia de Validator a partir de los datos de una clase FormRequest
     *
     * Si recibe el parámetro $id, este se envía a la función rules() que se utiliza para
     * definir las reglas de validación del FormRequest. Por lo tanto agregue el parámetro
     * en la función rules de su FormRequest public function rules($id = null)
     *
     * @param string $form_request_class
     * @param array $data
     * @param [type] $id
     * @return void
     */
    public function formRequestToValidator(string $form_request_class, array $data, $id = null)
    {
        $request = new ($form_request_class)();
        return Validator::make($data, $request->rules($id), $request->messages(), $request->attributes());
    }
}
