# Analysis Normal Form (ANF) Command-Line Utility

This NPM package provides resources for capturing clinical healthcare data represented via [Analysis Normal Form release v1](https://www.hl7.org/implement/standards/product_brief.cfm?product_id=523) using mainstream technologies, as the [ANF specification](https://github.com/HL7/ANF) itself is _only_ a logical model and accompanying editorial principles not offer technological guidance.

These resources are for collaborative research and evaluation by ANF stakeholders. Since HL7 does not ballot software implementations, this repository is maintained separately from the balloted specification(s).

If you ONLY want the static schemas, you may download them directly:

* **[ANF for PostgreSQL](./src/schema/anf-postgres-sti.sql)** : Uses UUIDv4 ids and native STI (single table inheritance).
* **[Parquet Examples]** : (Not yet implemented)

Department of Veterans Affairs (VA) users: This repository is distributed via NPMjs in alignment with the VA Technical Reference Model (TRM), though not all resources may be approved for use in VA context.

## Usage

`npm i -g anf-core` to install using your existing NodeJS environment.

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
