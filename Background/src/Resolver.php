<?php

namespace App\Background\src;

interface Resolver
{
    /**
     * Procesa la solicitud y retorna una respuesta para enviar al solicitante
     *
     * @param array|object $input_data
     * @param string|null $user_id
     * @return array
     */
    public function handle($input_data, $user_id): array;
}
