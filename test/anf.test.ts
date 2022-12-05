import path from 'path';
import fs from 'fs';
import { exec, ExecException } from 'child_process';
import { ANFVersion } from '../src/version';
import { SchemaDirectory } from '../src/schema/directory';

describe('`version` subcommand', () => {

    test('should report correct package version', async () => {
        let result = (await cli(['version'], __dirname)).stdout.trim();
        expect(result).toBe(ANFVersion.VERSION);
    });

});

describe('`schema` subcommand', () => {

    test('should fail without argument', async () => {
        let out = (await cli(['schema'], __dirname));
        expect(out.stdout.length).toBe(0);
        expect(out.stderr.length).toBeGreaterThanOrEqual(0);
        expect(out.code).toBe(1);
    });

    test('should emit postgres schema', async () => {
        let out = (await cli(['schema', 'postgres'], __dirname));
        expect(out.stdout.length).toBeGreaterThanOrEqual(10);
        expect(out.stderr.length).toBe(0);
        expect(out.code).toBe(0);

        let correct = fs.readFileSync(SchemaDirectory.POSTGRES).toString();
        // console.log(correct);
        expect(fs.readFileSync(out.stdout.trim()).toString()).toBe(correct);
    });
    

});

function cli(args: string[], cwd: string = __dirname) {
    return new Promise<{ code: number, error: ExecException | null, stdout: string, stderr: string }>(resolve => {
        exec(`ts-node ${path.resolve('src/bin/anf.ts')} ${args.join(' ')}`,
            { cwd },
            (error, stdout, stderr) => {
                resolve({
                    code: error && error.code ? error.code : 0,
                    error,
                    stdout,
                    stderr
                })
            })
    })
}
