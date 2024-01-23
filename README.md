# Analysis Normal Form (ANF) Command-Line Utility

These resources are for collaborative research and evaluation of [HL7 Analysis Normal Form release v1](https://www.hl7.org/implement/standards/product_brief.cfm?product_id=523) by possible ANF implementers interested in capturing clinical healthcare data in natively compatible forms. This project is released on [GitHub](https://github.com/bdrsolutionsllc/anf-core) for community collaboration, as well as via [NPM package](https://www.npmjs.com/package/anf-core) for the addition of future command-line utility functions. The [ANF specification](https://github.com/HL7/ANF) itself _only_ provides a logical model. As such, ANF's accompanying editorial principles do not offer implementation guidance or practical technology considerations.

Since HL7 does not ballot software implementations, this repository is maintained separately from the balloted specification(s).

If you ONLY want the static schemas, you may download them directly:

* **[ANF for PostgreSQL](./src/schema/anf-postgres-sti.sql)** : Uses UUIDv4 ids and native STI (single table inheritance).
* **[Parquet Examples]** : (Not yet implemented)

Department of Veterans Affairs (VA) users: This repository is distributed via NPMjs in alignment with the VA Technical Reference Model (TRM), though not all resources may be approved for use in VA context.

## Usage

`npm i -g anf-core` to install using your existing NodeJS environment.

`anf schema postgres` to emit a schema for PostgreSQL.
`anf schema parquet` (not yet implemented) to emit empty Parquet files.

## Development

```shell
npm i # to install project dependencies
npm test-watch # to rerun test cases upon changes
```

## License
Released under the Apache 2.0 license. See [LICENSE](LICENSE) file.

## Attribution
Preston Lee (GitHub: @preston)
