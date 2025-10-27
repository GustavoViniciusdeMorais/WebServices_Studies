# RabbitMQ Comands Example

### Requirement
Requires the docker container rabbitmq:3.9-management.
The commands only work inside it.
```yaml
my_rabbitmq:
    image: rabbitmq:3.9-management
    container_name: my_rabbitmq
    ports:
        - '5672:5672'
        - '15672:15672'
    networks:
        gus-php-network:
            ipv4_address: 12.0.0.9
```

### Step 1: Start RabbitMQ Server

Make sure your RabbitMQ server is running. If it's not installed, you can install it following the RabbitMQ installation guide.

### Step 2: Create an Exchange

```bash
rabbitmqadmin declare exchange name=my_exchange type=direct
```

This command creates a direct exchange named `my_exchange`. You can replace `direct` with other types such as `fanout`, `topic`, etc., based on your needs.

### Step 3: Create a Queue

```bash
rabbitmqadmin declare queue name=my_queue
```

This command creates a queue named `my_queue`. You can customize the name as needed.

### Step 4: Bind Exchange to Queue

```bash
rabbitmqadmin declare binding source=my_exchange destination=my_queue routing_key=my_routing_key
```

This command binds the `my_exchange` exchange to the `my_queue` queue with a routing key of `my_routing_key`. Adjust the routing key as necessary.

### Step 5: Verify Configuration

You can use the following commands to verify the configurations:

- To list exchanges:

  ```bash
  rabbitmqadmin list exchanges
  ```

- To list queues:

  ```bash
  rabbitmqadmin list queues
  ```

- To list bindings:

  ```bash
  rabbitmqadmin list bindings
  ```

Make sure that the exchange, queue, and binding are listed correctly.

### Step 6: Publish a Message to the Exchange

```bash
rabbitmqadmin publish exchange=my_exchange routing_key=my_routing_key payload="Hello RabbitMQ!"
```

This command publishes a message with the payload "Hello RabbitMQ!" to the `my_exchange` exchange with the specified routing key.

### Step 7: Consume Messages from the Queue

You can use the following command to consume messages from the queue:

```bash
rabbitmqadmin get queue=my_queue
```

This command retrieves and prints a message from the `my_queue` queue.


To clean (purge) all messages from a RabbitMQ queue using `rabbitmqadmin`, you can use the following command:

```bash
rabbitmqadmin purge queue name=<your_queue_name>
```

Replace `<your_queue_name>` with the actual name of the queue from which you want to remove all messages.

Please note that this operation will remove all messages from the specified queue. Make sure to use it carefully, especially in a production environment, as this action is not reversible.

Make sure to adapt the names and configurations based on your specific requirements. These commands assume that you have the RabbitMQ admin command-line tool (`rabbitmqadmin`) installed and configured on your system. Adjust the paths and authentication details if needed.
