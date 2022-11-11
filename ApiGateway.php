<?php

namespace App\Services;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Http;

class ApiGateway
{
    /**
     * Solicitud http a un servicio del cluster
     * @param $method
     * @param $requestUrl
     * @param array $formParams
     * @param array $headers
     * @return array
     */
    public static function performRequest($method, $requestUrl, $formParams = [], $headers = []): array
    {
        $base_uri = config("app.api_gateway.base_uri");

        $func = strtolower($method);

        $request = Http::baseUrl($base_uri);

        $has_file = false;

        foreach ($formParams as $key => $value) {
            if ($value instanceof UploadedFile) {
                $has_file = true;
            }
        }

        if ($has_file) {
            foreach ($formParams as $key => $value) {
                if ($value instanceof UploadedFile) {
                    $request = $request->attach($key, $value->get(), $value->getClientOriginalName());
                }
            }
        } else {
            if ($func != 'get' && $func != 'delete') {
                $request = $request->asForm();
            }
        }

        $response = $request->$func($requestUrl, $formParams);

        /*if (isset($this->secret)) {
            $headers['Authorization'] = $this->secret;
        }*/

        $data = json_decode($response->body(), true);

        if ($data == null) {
            $data = ['error' => strlen($response->body()) ? $response->body() : "Error interno del servidor", 'code' => 500];
        }

        return $data;
    }
}
