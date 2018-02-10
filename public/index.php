<?php

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require_once(__DIR__ . '/../bootstrap/app.php');

$app = new \Slim\App;
$app->get('/', function(Request $request, Response $response) {
    $response->getBody()->write('Hello, world!');
});
$app->run();
