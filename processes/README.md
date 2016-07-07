# Actor concurrency model

1. Each actor is a process
2. Each process performs a speficic task
3. To tell a process to do something, you need to send it a message. The process
   can reply by sending back another message
4. The messages the process acts upon are pattern matched
5. Processes do not share any information with other processes
