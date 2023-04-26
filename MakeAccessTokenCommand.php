<?php

namespace App\Console\Commands;

use App\Helpers\StubFormatter;
use Illuminate\Console\Command;
use Illuminate\Filesystem\Filesystem;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Str;
use Illuminate\Support\Pluralizer;

class MakeAccessTokenCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'make:access_token';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Crea un nuevo token de acceso al servicio';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {

        $this->comment('Agregando token ...');
        $this->addAccessToken();
        $this->info('Token agregado con éxito');
    }

    /**
     * Agrega el token de acceso al archivo .env
     *
     * @return void
     */
    public function addAccessToken()
    {
        $token = Str::random(rand(20, 30));
        $file = fopen(base_path('.env'), 'r+') or die('Error');
        $content = "";
        $is_added = false;
        while ($line = fgets($file)) {
            //Ya existe el key ACCESS_TOKENS y no se a añadido el nuevo token
            if (str_contains($line, 'ACCESS_TOKENS=') && !$is_added) {
                //Si hay más de un token separa por coma
                $separator = strlen(trim($line)) > 14 ? "," : "";
                $line = str_replace("ACCESS_TOKENS=", "ACCESS_TOKENS=$token$separator", $line);
                $is_added = true;
            }
            $content .= $line;
        }

        if(!$is_added) {
            $content .= "ACCESS_TOKENS=$token\n";
        }
        rewind($file);
        fwrite($file, $content);
        fclose($file);
    }
}
