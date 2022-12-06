#!/usr/bin/env node
// The `node` runtime (instead of ts-node) is used to be runnable in compiled .js form.
// Author: Preston Lee

import { Command, Help } from 'commander';
import * as fs from 'fs';
import path from 'path';
import { ANFPaquetSchema } from '../parquet/anf_parquet_schema';
import { ANFSchemaDirectory } from '../schema/directory';
import { ANFVersion } from '../version';

const program = new Command();
const description = `Analysis Normal Form (ANF) utilities, based on the HL7/Logica v1 informative ballot.`

program.name('anf').description(description);

program.command('version')
    .description('Package version information.')
    .action(options => {
        console.log(ANFVersion.VERSION);
    });

const schema_command = program.command('schema');

// schema_command.action(() => schema_command.help());


schema_command.command('postgres')
    .description("Prints the path to the bundled physical reference implementation schema for import into the corresponding database system.")
    // .argument("<postgres|parquet>", "SQL implementation dialect to emit.")
    .action((options) => {
        console.log(ANFSchemaDirectory.POSTGRES);
    });

schema_command.command("parquet", "Columnar Parquet format files.")
    .description("Generates Parquet schema files for use with data science and analytics systems.")
    .argument('<directory>', 'Output directory that files will be written into.')
    .action((directory, options) => {
        // console.log('Not fully implemented!');
        let schema = new ANFPaquetSchema(directory);
        schema.generate().then(() => { console.log('Done.') });
    });


program.parse();
