#!/usr/bin/env node
// The `node` runtime (instead of ts-node) is used to be runnable in compiled .js form.
// Author: Preston Lee

import { program } from 'commander';
import * as fs from 'fs';
import path from 'path';
import { SchemaDirectory } from '../schema/directory';
import { ANFVersion } from '../version';

const description = `Analysis Normal Form (ANF) utilities, based on the HL7/Logica v1 informative ballot.`

program.name('anf').description(description)


program.command('version')
    .description('Package version information.')
    .action(options => {
        console.log(ANFVersion.VERSION);
    });

program.command('schema')
    .description("Prints the path to the bundled physical reference implementation schema for import into the corresponding database system.")
    .argument("<postgres|parquet>", "SQL implementation dialect to emit.")
    .action((dialect, options) => {
        switch (dialect) {
            case 'postgres':
                console.log(SchemaDirectory.POSTGRES);
                // const raw = fs.readFileSync(path.normalize(SchemaDirectory.POSTGRES)).toString();
                break;
            case 'parquet':
                console.log('Not yet implemented.');
                break;
            default:
                program.error("Unsupported dialect '" + dialect + "'.");
                break;

        }
    });

program.parse();
