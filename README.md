## PHP Queue
```bash
# in php container
php src/worker.php

# in queue container
rabbitmqadmin declare exchange name=my_exchange type=direct

rabbitmqadmin declare queue name=my_queue

rabbitmqadmin declare binding source=my_exchange destination=my_queue routing_key=my_routing_key

rabbitmqadmin publish exchange=my_exchange routing_key=my_routing_key payload="Hello RabbitMQ!"

```
## PHP Queue
#### Containers
```bash
docker compose up -d --build api my_rabbitmq
```
#### Test Queue
In panel localhost:15672 click in Queues => Get messages
```bash
# in php container
php src/worker.php

# in queue container
rabbitmqadmin declare exchange name=my_exchange type=direct

rabbitmqadmin declare queue name=my_queue

rabbitmqadmin declare binding source=my_exchange destination=my_queue routing_key=my_routing_key

rabbitmqadmin publish exchange=my_exchange routing_key=my_routing_key payload="Hello RabbitMQ!"

```
