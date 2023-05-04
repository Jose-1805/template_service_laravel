<?php

namespace App\Background\src;

use Illuminate\Support\Facades\Log;

class BackgroundRequestResolver
{
    private $event;

    // Este campo debe contener los datos de la solicitud en segundo plano
    // (id, event, state, input_data, output_data, user_id)
    private $data;

    private $event_response = "background_request_result";
    private $queue_response = "api_gateway_queue.default";
    private $publish_response = true;


    public function __construct(string $event, string $data)
    {
        $this->event = $event;
        $this->data = json_decode($data, true);
    }

    /**
     * Publica el resultado de la ejecución en segundo plano
     *
     * @param [string] $queue
     * @return void
     */
    public function publishResult(): void
    {
        if($queue) {
            \Amqp::publish($this->event_response, $this->responseData(), ["queue" => $this->queue_response]);
        }
    }

    /**
     * Datos de respuesta del resultado de la solicitud
     *
     * @return string
     */
    public function responseData(): string
    {
        $response = [
            "id" => $this->data["id"],
            "event" => $this->data["event"],
            "output_data" => $this->data["output_data"],
        ];

        return json_encode($response);
    }

    /**
     * Resuelve la solicitud en segundo plano
     *
     * @return void
     */
    public function resolve(): void
    {
        $resolver_class = config('background.events.'.$this->event);
        if($resolver_class) {
            $resolver = new ($resolver_class)();
            $data_response = $resolver->handle($this->data["input_data"], $this->data["user_id"]);
            $this->data["output_data"] = array_key_exists("response", $data_response) && is_array($data_response["response"]) ? $data_response["response"] : [] ;
            // Se envían datos para cambiar el destino de la respuesta
            if(array_key_exists("options", $data_response) && is_array($data_response["options"])) {
                if(array_key_exists("event", $data_response["options"]) && $data_response["options"]["event"]) {
                    $this->event_response = $data_response["options"]["event"];
                }
                if(array_key_exists("queue", $data_response["options"]) && $data_response["options"]["queue"]) {
                    $this->queue_response = $data_response["options"]["queue"];
                }
                if(array_key_exists("publish", $data_response["options"])) {
                    $this->publish_response = $data_response["options"]["publish"] ? true : false;
                }
            }
            $this->publish_response && $this->publishResult();
        } else {
            Log::warning("No se encontró configuración para el evento ".$this->event);
        }
    }
}
