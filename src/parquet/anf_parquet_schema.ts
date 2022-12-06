// Author: Preston Lee

import { ParquetSchema, ParquetWriter } from "parquets";
import path from "path";

export class ANFPaquetSchema {

    public static STATEMENT_SCHEMA_FILE_NAME = "statement.parquet";

    constructor(public directory: string) {
    }

    public fullPathFor(file: string): string {
        return path.normalize(path.join(this.directory, file));
    }

    public async generate() {
        let statement = new ParquetSchema({
            id: { type: 'FIXED_LEN_BYTE_ARRAY', typeLength: 16 },
            circumstance_timing_id: { type: 'FIXED_LEN_BYTE_ARRAY', typeLength: 16 },
            time_id: { type: 'FIXED_LEN_BYTE_ARRAY', typeLength: 16 },
            subject_of_record_ID: { type: 'FIXED_LEN_BYTE_ARRAY', typeLength: 16 },
            subject_of_information_id: { type: 'FIXED_LEN_BYTE_ARRAY', typeLength: 16 },
            topic_id: { type: 'FIXED_LEN_BYTE_ARRAY', typeLength: 16 },
            type_id: { type: 'FIXED_LEN_BYTE_ARRAY', typeLength: 16 }
        });
        let writer = await ParquetWriter.openFile(statement, this.fullPathFor(ANFPaquetSchema.STATEMENT_SCHEMA_FILE_NAME));
        writer.close();
    }

}