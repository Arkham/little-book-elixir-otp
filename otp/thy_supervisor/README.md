# ThySupervisor

1. `{:ok, sup_pid} = ThySupervisor.start_link([])`
2. `{:ok, child_pid} = ThySupervisor.start_child(sup_pid, {ThyWorker, :star
t_link, []})`
3. `Process.info(sup_pid, :links)`
4. `self`
5. `Process.exit(child_pid, :crash)`
6. `Process.info(sup_pid, :links)`
7. `ThySupervisor.which_children(sup_pid)`
