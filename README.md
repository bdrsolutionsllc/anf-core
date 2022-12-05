# Analysis Normal Form (ANF) Command-Line Utility

`anf` is an npm package of resources for capturing clinical healthcare data represented in [Analysis Normal Form release v1](https://www.hl7.org/implement/standards/product_brief.cfm?product_id=523) using mainstream database technologies, as the [ANF specification](https://github.com/HL7/ANF) itself is _only_ a logical model and accompanying editoring principles.

These resources are for research and evaluation by ANF stakeholders. As HL7 does not ballot software implementations, this repository is maintained separately from the specification itself.

If you ONLY want the static schemas, you may download them directly:

* **[ANF for PostgreSQL](./src/schema/anf-postgres-sti.sql)** : Uses UUIDv4 ids and native STI (single table inheritance).
* **[Parquet]** : TODO


## Usage

`npm i -g anf` to install using your existing NodeJS environment.

`anf schema postgres` to emit a schema for PostgreSQL.
`anf schema parquet` to emit empty Parquet files.

## Development

```shell
npm i # to install project dependencies
npm test-watch # to rerun test cases upon changes
```

## License

Apache 2.0

## Attribution

Preston Lee (@preston)
