# ora2pg
ora2pg docker image

## Here's a basic instruction for getting started.

1. Create a volume for your container
2. Go right to bash of the container and make sure to mount the volume (replace <host_volume_dir> with actual dir)
```bash
docker run -i -t --rm --privileged=true -v <host_volume_dir>:/data --name ora2pg remulito/ora2pg /bin/bash
```
3. Navigate to volume directory 
```bash
cd /data
```
4. Generate ora2pg project via command: 
```bash
ora2pg --project_base . --init_project my_project
```
5. Update ora2pg config file (at config folder) and run your ora2pg operations, check https://ora2pg.darold.net for ora2pg documentation.
