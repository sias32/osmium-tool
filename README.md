# osmium-tool

Osmium Tool on Docker

Read the tool [docs](https://osmcode.org/osmium-tool/)

GitHub - [Official](https://github.com/osmcode/osmium-tool) [Me](https://hub.docker.com/r/sias32/osmium-tool)

Example usage:

Extract Greece from the planet download:

```
docker run -it -w /work -v $(pwd):/work sias32/osmium-tool extract --bbox=17.682871,33.679590,30.404538,42.269466 -o one.map.pbf two.map.pbf
```

Filter all buildings, highways and beaches from the extract:

```
docker run -w /work -v $(pwd):/work sias32/osmium-tool tags-filter -o one.map.pbf two.map.pbf building highway natural=beach
```

Merge maps:

```
docker run -w /work -v $(pwd):/work sias32/osmium-tool merge /wkd/one.map.pbf /wkd/two.map.pbf -o merge.map.pbf
```
