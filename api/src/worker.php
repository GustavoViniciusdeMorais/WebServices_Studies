<?php

require_once __DIR__ . '/../vendor/autoload.php';

use PhpAmqpLib\Connection\AMQPStreamConnection;

// should use getenv
// my_rabbitmq container
$connection = new AMQPStreamConnection('my_rabbitmq', 5672, 'guest', 'guest');
$channel = $connection->channel();

$channel->queue_declare('my_queue', false, true, false, false);

echo "Waiting for messages. To exit press CTRL+C\n";

$callback = function ($msg) {
    echo "Received: " . $msg->body . "\n";
    // Process your message here
    $msg->ack();
};

$channel->basic_consume('my_queue', '', false, false, false, false, $callback);

try {
    $channel->consume();
} catch (\Throwable $exception) {
    echo $exception->getMessage();
}

$channel->close();
$connection->close();
