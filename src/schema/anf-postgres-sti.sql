/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : PostgreSQL
 Source Server Version : 140006 (140006)
 Source Host           : localhost:5432
 Source Catalog        : anf_development
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 140006 (140006)
 File Encoding         : 65001

 Date: 05/12/2022 14:51:50
*/


-- ----------------------------
-- Table structure for associated_statements
-- ----------------------------
DROP TABLE IF EXISTS "associated_statements" CASCADE;
CREATE TABLE "associated_statements" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "semantic_id" uuid NOT NULL,
  "target_id" uuid NOT NULL,
  "source_id" uuid NOT NULL
)
;
COMMENT ON COLUMN "associated_statements"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON COLUMN "associated_statements"."semantic_id" IS 'A logical expression to capture how the target statement is associated (e.g. a precondition, an interpretation, a component).';
COMMENT ON COLUMN "associated_statements"."target_id" IS 'Identifier of the statement being associated with the source.';
COMMENT ON COLUMN "associated_statements"."source_id" IS 'The statement to associate.';
COMMENT ON TABLE "associated_statements" IS 'Specifies how a statement may be associated with another statement.';

-- ----------------------------
-- Table structure for logical_expressions
-- ----------------------------
DROP TABLE IF EXISTS "logical_expressions" CASCADE;
CREATE TABLE "logical_expressions" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "expression" text COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "logical_expressions"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON COLUMN "logical_expressions"."expression" IS 'Can be represented using FHIR Expression structure or a similar standard-based syntax (e.g. SNOMED CT Expression Constrain Language - ECL). The expression must use valid, standard-based terminology.';
COMMENT ON TABLE "logical_expressions" IS 'Wrappers for logical expression represented in an external language.';

-- ----------------------------
-- Table structure for measures
-- ----------------------------
DROP TABLE IF EXISTS "measures" CASCADE;
CREATE TABLE "measures" (
  "lower_bound" float4 NOT NULL,
  "include_lower_bound" bool NOT NULL,
  "upper_bound" float4 NOT NULL,
  "include_upper_bound" bool NOT NULL,
  "resolution" float4,
  "semantic_id" uuid NOT NULL,
  "id" uuid NOT NULL DEFAULT uuid_generate_v4()
)
;
COMMENT ON COLUMN "measures"."lower_bound" IS 'The lower bound of a measurable element. This can be the lower bound of a range.';
COMMENT ON COLUMN "measures"."include_lower_bound" IS 'Whether the lower bound in the interval is included in the interval. The inclusion or exclusion of lower bound is needed to express measurable elements which include relative properties, such as "greater than", "less than" and others.';
COMMENT ON COLUMN "measures"."upper_bound" IS 'The upper bound of a measurable element. This can be the upper boundary of a range.';
COMMENT ON COLUMN "measures"."include_upper_bound" IS 'Whether the upper bound in the interval is included in the interval. Similar to lower bound, where the measurable element has relative properties, the same rules apply. If the upper bound of a measure is not defined, e.g. "blood glucose measurement daily for at least 2 weeks", the upper bound will be captured as "INF" (infinite). Infinite as an upper bound is never included. If "true" the upper bound is part of the interval.';
COMMENT ON COLUMN "measures"."resolution" IS 'The possible or allowed increments in which the measured "thing" can be counted. In the example of the systolic blood pressure of 120 mmHg, the resolution is "1", because the blood pressure measurement result can be counted in 1 mmHg increments. The Resolution is not always defined or known.';
COMMENT ON COLUMN "measures"."semantic_id" IS 'A unit of measure or scale specified by the interval values. It is described using a logical expression using standard-based terminology (i.e. SNOMED CT).';
COMMENT ON COLUMN "measures"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON TABLE "measures" IS 'Captures measurable elements of clinical statements, e.g. the results of test procedures, time periods, frequencies of repetitions for procedures or medication administrations. The measure formally represents a numeric interval between two non-negative real numbers with a semantic and precision/reso- lution. The interval can be open or closed depending on whether the upper and lower bounds are included in the measure interval.

The measure provides a single way to represent both "presence" or "absence" values and numeric values for a phenomenon. In general, the interval value represents the numeric range within which the observed value of a phenomenon occurs. Note that this formalism allows both exact values and ranges of values to be expressed. In the case that the beginning and end points of an interval are the same value, the meaning is that the value of the phenomenon is exactly that value.';

-- ----------------------------
-- Table structure for narrative_circumstances
-- ----------------------------
DROP TABLE IF EXISTS "narrative_circumstances" CASCADE;
CREATE TABLE "narrative_circumstances" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "circumstance_timing_id" uuid NOT NULL,
  "time_id" uuid NOT NULL,
  "subject_of_record_id" uuid NOT NULL,
  "subject_of_information_id" uuid NOT NULL,
  "topic_id" uuid NOT NULL,
  "type_id" uuid NOT NULL,
  "text" text COLLATE "pg_catalog"."default"
)
INHERITS ("public"."statements")
;
COMMENT ON COLUMN "narrative_circumstances"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON COLUMN "narrative_circumstances"."text" IS 'Text description of circumstances.';
COMMENT ON TABLE "narrative_circumstances" IS 'This class is used to describe the circumstances of a clinical statement using natural language/text rather than a structure. This class may be used to specify either a performance or request circumstance.';

-- ----------------------------
-- Table structure for participants
-- ----------------------------
DROP TABLE IF EXISTS "participants" CASCADE;
CREATE TABLE "participants" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "practitioner_id" uuid NOT NULL,
  "code_id" uuid
)
;
COMMENT ON COLUMN "participants"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON COLUMN "participants"."practitioner_id" IS 'Identifier of the participating practitioner.';
COMMENT ON COLUMN "participants"."code_id" IS 'Role(s) which this practitioner is authorized to perform.';
COMMENT ON TABLE "participants" IS 'The role/specialties/services that a practitioner may perform relative to an ANF statement.';

-- ----------------------------
-- Table structure for performance_circumstance_participants
-- ----------------------------
DROP TABLE IF EXISTS "performance_circumstance_participants" CASCADE;
CREATE TABLE "performance_circumstance_participants" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "performance_circumstance_id" uuid NOT NULL,
  "participant_id" uuid NOT NULL
)
;
COMMENT ON COLUMN "performance_circumstance_participants"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON TABLE "performance_circumstance_participants" IS 'Many-to-many table associating performance_circumstances to participants.';

-- ----------------------------
-- Table structure for performance_circumstances
-- ----------------------------
DROP TABLE IF EXISTS "performance_circumstances" CASCADE;
CREATE TABLE "performance_circumstances" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "status_id" uuid NOT NULL,
  "result_id" uuid NOT NULL,
  "health_risk_id" uuid NOT NULL,
  "reference_range_id" uuid NOT NULL,
  "circumstance_timing_id" uuid NOT NULL,
  "time_id" uuid NOT NULL,
  "subject_of_record_id" uuid NOT NULL,
  "subject_of_information_id" uuid NOT NULL,
  "topic_id" uuid NOT NULL,
  "type_id" uuid NOT NULL
)
INHERITS ("public"."statements")
;
COMMENT ON COLUMN "performance_circumstances"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON COLUMN "performance_circumstances"."status_id" IS 'A coded value representing the current status of the intervention (e.g. "completed"). This data element is not intended as a substitute for workflow specification.';
COMMENT ON COLUMN "performance_circumstances"."result_id" IS 'Intervention result as a measure.';
COMMENT ON COLUMN "performance_circumstances"."health_risk_id" IS 'Optional data element is used to flag a result with coded values to describe the health risk associated with result of the ANF statement (e.g. ''low'', ''normal'', high'', ''critically low'', or ''critically high'').';
COMMENT ON COLUMN "performance_circumstances"."reference_range_id" IS 'The interval of values that are normal for the observation/finding described by the "topic" for this "subject". It refers to reference for the patient/subject with these conditions.';
COMMENT ON TABLE "performance_circumstances" IS 'This class describes the circumstances associated with a statement. It is used when an action or observation is performed and it specifies the result of intervention using both measure and a coded status . For example, "Insulin placed on hold 24 hours prior to catheterization" would have a status of "On hold". A typical, successfully completed procedure would have a status of "Completed".';

-- ----------------------------
-- Table structure for practitioners
-- ----------------------------
DROP TABLE IF EXISTS "practitioners" CASCADE;
CREATE TABLE "practitioners" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4()
)
;
COMMENT ON COLUMN "practitioners"."id" IS 'Primary key of UUIDv4 type.';

-- ----------------------------
-- Table structure for repetitions
-- ----------------------------
DROP TABLE IF EXISTS "repetitions" CASCADE;
CREATE TABLE "repetitions" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "period_start_id" uuid NOT NULL,
  "period_duration_id" uuid NOT NULL,
  "event_separation_id" uuid NOT NULL,
  "event_duration_id" uuid,
  "event_frequency_id" uuid NOT NULL
)
;
COMMENT ON COLUMN "repetitions"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON COLUMN "repetitions"."period_start_id" IS 'Represents when a repeated action should begin (e.g. NOW). If it is not specified, a default value of [0,INF) will be used. NOW is represented as a interval of time values. If the timing is precise the lower and upper bounds may be identical; otherwise the interval would match the precision of the original time observations.';
COMMENT ON COLUMN "repetitions"."period_duration_id" IS 'Represents how long a repeated action should persist (e.g. for a year). If it is not specified, a default value of [0,INF) will be used.';
COMMENT ON COLUMN "repetitions"."event_separation_id" IS 'Represents how long between actions (e.g. 1 week). If it is not specified, a default value of [0,INF) will be used.';
COMMENT ON COLUMN "repetitions"."event_duration_id" IS 'Represents how long a repetition should persist (e.g. for 2 hours). If it is not specified, a default value of [0,INF) will be used.';
COMMENT ON COLUMN "repetitions"."event_frequency_id" IS 'Represents how often the action should occur (e.g. 4 times per month). If it is not specified, a default value of [0, INF) will be used.';
COMMENT ON TABLE "repetitions" IS 'Used to represent when an action is requested for more than a single occurrence.';

-- ----------------------------
-- Table structure for request_circumstance_associated_statements
-- ----------------------------
DROP TABLE IF EXISTS "request_circumstance_associated_statements" CASCADE;
CREATE TABLE "request_circumstance_associated_statements" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "request_circumstance_id" uuid NOT NULL,
  "associated_statement_id" uuid NOT NULL
)
;
COMMENT ON COLUMN "request_circumstance_associated_statements"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON TABLE "request_circumstance_associated_statements" IS 'Many-to-many table associating request_circumstances to associated_statements.';

-- ----------------------------
-- Table structure for request_circumstance_participants
-- ----------------------------
DROP TABLE IF EXISTS "request_circumstance_participants" CASCADE;
CREATE TABLE "request_circumstance_participants" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "request_circumstance_id" uuid NOT NULL,
  "participant_id" uuid NOT NULL
)
;
COMMENT ON COLUMN "request_circumstance_participants"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON TABLE "request_circumstance_participants" IS 'Many-to-many table associating request_circumstances to participants.';

-- ----------------------------
-- Table structure for request_circumstances
-- ----------------------------
DROP TABLE IF EXISTS "request_circumstances" CASCADE;
CREATE TABLE "request_circumstances" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "priority_id" uuid NOT NULL,
  "circumstance_timing_id" uuid NOT NULL,
  "time_id" uuid NOT NULL,
  "subject_of_record_id" uuid NOT NULL,
  "subject_of_information_id" uuid NOT NULL,
  "topic_id" uuid NOT NULL,
  "type_id" uuid NOT NULL,
  "requested_result_id" uuid NOT NULL,
  "repetition_id" uuid NOT NULL
)
INHERITS ("public"."statements")
;
COMMENT ON COLUMN "request_circumstances"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON COLUMN "request_circumstances"."priority_id" IS 'The priority with which a requested action has to be carried out, e.g. “routine” or “stat”. By default a Request will be considered "routine" unless otherwise specified.';
COMMENT ON COLUMN "request_circumstances"."requested_result_id" IS 'The measurable result; it may specify that something must be completed (e.g. how many sessions of counseling, how many refills, etc.) are requested or that something be done.';
COMMENT ON COLUMN "request_circumstances"."repetition_id" IS 'Describes when an action is requested for more than a single occurrence using the "measures" data structure.';
COMMENT ON TABLE "request_circumstances" IS 'A Request for Action clinical statement describes a request made by a clinician. Most of the times, but not always, the object of the request (e.g., lab test, medication order) will be fulfilled by someone other than the clinician (e.g., lab technician, pharmacist) making the request. All detailed information about the request will be documented in this clinical statement, such as patient must fast for 12 hours before having a lipids blood test.';

-- ----------------------------
-- Table structure for statement_authors
-- ----------------------------
DROP TABLE IF EXISTS "statement_authors" CASCADE;
CREATE TABLE "statement_authors" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "statement_id" uuid NOT NULL,
  "practitioner_id" uuid NOT NULL
)
;
COMMENT ON COLUMN "statement_authors"."id" IS 'Primary key of UUIDv4 type.';

-- ----------------------------
-- Table structure for statement_circumstance_purposes
-- ----------------------------
DROP TABLE IF EXISTS "statement_circumstance_purposes" CASCADE;
CREATE TABLE "statement_circumstance_purposes" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "statement_id" uuid NOT NULL,
  "logical_expression_id" uuid NOT NULL
)
;
COMMENT ON COLUMN "statement_circumstance_purposes"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON TABLE "statement_circumstance_purposes" IS 'Many-to-many table associating statements with logical_expressions capturing the circumstances.';

-- ----------------------------
-- Table structure for statements
-- ----------------------------
DROP TABLE IF EXISTS "statements" CASCADE;
CREATE TABLE "statements" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "circumstance_timing_id" uuid NOT NULL,
  "time_id" uuid NOT NULL,
  "subject_of_record_id" uuid NOT NULL,
  "subject_of_information_id" uuid NOT NULL,
  "topic_id" uuid NOT NULL,
  "type_id" uuid NOT NULL
)
;
COMMENT ON COLUMN "statements"."id" IS 'Primary key of UUIDv4 type.';
COMMENT ON COLUMN "statements"."circumstance_timing_id" IS 'Timing is used to capture a time or time range.';
COMMENT ON COLUMN "statements"."time_id" IS 'Describes when the statement was documented. Is it''s expressed as a measure.';
COMMENT ON COLUMN "statements"."subject_of_record_id" IS 'Reference to the patient clinical record in which this statement is contained. ';
COMMENT ON COLUMN "statements"."subject_of_information_id" IS 'A logical expression describing the subject of the statement; it''s used to express WHO the clinical statement is about. A patient''s clinical record may contain statements not only about the patient, but also statements about children, relatives and donors.';
COMMENT ON COLUMN "statements"."topic_id" IS 'Distinguishes between a performance (''performed'') and a request (''requested''). Performances may be observational performances, e.g. the observation of a clinical finding or disorder being present or absent. They can also be a procedure or intervention which has been performed on the subject of record in the past, e.g. “a procedure using a 12-lead electrocardiogram”. Performances can – but do not have to – include quantitative or qualitative results.';
COMMENT ON COLUMN "statements"."type_id" IS 'This data element distinguishes between a performance (''performed'') and a request (''requested''). Performances may be observational performances, e.g. the observation of a clinical finding or disorder being present or absent. They can also be a procedure or intervention which has been performed on the subject of record in the past, e.g. “a procedure using a 12-lead electrocardiogram”. Performances can – but do not have to – include quantitative or qualitative results.';
COMMENT ON TABLE "statements" IS 'This is the main class of the ANF reference model and it describes the structure of a normalized clinical statement that complies with ANF.';

-- ----------------------------
-- Function structure for uuid_generate_v1
-- ----------------------------
DROP FUNCTION IF EXISTS "uuid_generate_v1"() CASCADE;
CREATE OR REPLACE FUNCTION "uuid_generate_v1"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v1mc
-- ----------------------------
DROP FUNCTION IF EXISTS "uuid_generate_v1mc"() CASCADE;
CREATE OR REPLACE FUNCTION "uuid_generate_v1mc"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1mc'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v3
-- ----------------------------
DROP FUNCTION IF EXISTS "uuid_generate_v3"("namespace" uuid, "name" text) CASCADE;
CREATE OR REPLACE FUNCTION "uuid_generate_v3"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v3'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v4
-- ----------------------------
DROP FUNCTION IF EXISTS "uuid_generate_v4"() CASCADE;
CREATE OR REPLACE FUNCTION "uuid_generate_v4"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v4'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v5
-- ----------------------------
DROP FUNCTION IF EXISTS "uuid_generate_v5"("namespace" uuid, "name" text) CASCADE;
CREATE OR REPLACE FUNCTION "uuid_generate_v5"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v5'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_nil
-- ----------------------------
DROP FUNCTION IF EXISTS "uuid_nil"() CASCADE;
CREATE OR REPLACE FUNCTION "uuid_nil"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_nil'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_dns
-- ----------------------------
DROP FUNCTION IF EXISTS "uuid_ns_dns"() CASCADE;
CREATE OR REPLACE FUNCTION "uuid_ns_dns"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_dns'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_oid
-- ----------------------------
DROP FUNCTION IF EXISTS "uuid_ns_oid"() CASCADE;
CREATE OR REPLACE FUNCTION "uuid_ns_oid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_url
-- ----------------------------
DROP FUNCTION IF EXISTS "uuid_ns_url"() CASCADE;
CREATE OR REPLACE FUNCTION "uuid_ns_url"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_url'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_x500
-- ----------------------------
DROP FUNCTION IF EXISTS "uuid_ns_x500"() CASCADE;
CREATE OR REPLACE FUNCTION "uuid_ns_x500"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_x500'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Indexes structure for table associated_statements
-- ----------------------------
CREATE INDEX "source_id_semantic_id_idx" ON "associated_statements" USING btree (
  "semantic_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "source_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "source_id_target_id_semantic_id_idx" ON "associated_statements" USING btree (
  "semantic_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "target_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "source_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "target_id_semantic_id_idx" ON "associated_statements" USING btree (
  "semantic_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "target_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table associated_statements
-- ----------------------------
ALTER TABLE "associated_statements" ADD CONSTRAINT "associated_statements_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table logical_expressions
-- ----------------------------
ALTER TABLE "logical_expressions" ADD CONSTRAINT "logical_expression_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table measures
-- ----------------------------
ALTER TABLE "measures" ADD CONSTRAINT "measure_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table narrative_circumstances
-- ----------------------------
ALTER TABLE "narrative_circumstances" ADD CONSTRAINT "narrative_circumstance_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table participants
-- ----------------------------
CREATE UNIQUE INDEX "practitioner_id_code_id_idx" ON "participants" USING btree (
  "practitioner_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "code_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table participants
-- ----------------------------
ALTER TABLE "participants" ADD CONSTRAINT "participant_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table performance_circumstance_participants
-- ----------------------------
CREATE UNIQUE INDEX "id_idx" ON "performance_circumstance_participants" USING btree (
  "id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "performance_circumstance_id_participant_id_idx" ON "performance_circumstance_participants" USING btree (
  "performance_circumstance_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "participant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table performance_circumstance_participants
-- ----------------------------
ALTER TABLE "performance_circumstance_participants" ADD CONSTRAINT "performance_circumstance_participants_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table performance_circumstances
-- ----------------------------
ALTER TABLE "performance_circumstances" ADD CONSTRAINT "performance_statement_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table practitioners
-- ----------------------------
ALTER TABLE "practitioners" ADD CONSTRAINT "practitioner_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table repetitions
-- ----------------------------
ALTER TABLE "repetitions" ADD CONSTRAINT "repetition_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table request_circumstance_associated_statements
-- ----------------------------
CREATE UNIQUE INDEX "request_circumstance_id_associated_statement_id_idx" ON "request_circumstance_associated_statements" USING btree (
  "request_circumstance_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "associated_statement_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table request_circumstance_associated_statements
-- ----------------------------
ALTER TABLE "request_circumstance_associated_statements" ADD CONSTRAINT "request_circumstance_associated_statements_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table request_circumstance_participants
-- ----------------------------
CREATE UNIQUE INDEX "request_circumstance_id_participant_id_idx" ON "request_circumstance_participants" USING btree (
  "request_circumstance_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "participant_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table request_circumstance_participants
-- ----------------------------
ALTER TABLE "request_circumstance_participants" ADD CONSTRAINT "request_circumstance_associated_statements_copy1_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table request_circumstances
-- ----------------------------
ALTER TABLE "request_circumstances" ADD CONSTRAINT "request_circumstance_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table statement_authors
-- ----------------------------
CREATE UNIQUE INDEX "statement_id_practitioner_id_idx" ON "statement_authors" USING btree (
  "statement_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "practitioner_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table statement_authors
-- ----------------------------
ALTER TABLE "statement_authors" ADD CONSTRAINT "statement_practitioner_uniq" UNIQUE ("statement_id", "practitioner_id");
COMMENT ON CONSTRAINT "statement_practitioner_uniq" ON "statement_authors" IS 'A given person cannot author the same thing twice.';

-- ----------------------------
-- Primary Key structure for table statement_authors
-- ----------------------------
ALTER TABLE "statement_authors" ADD CONSTRAINT "statement_author_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table statement_circumstance_purposes
-- ----------------------------
CREATE UNIQUE INDEX "statement_id_logical_expression_id_idx" ON "statement_circumstance_purposes" USING btree (
  "statement_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "logical_expression_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table statement_circumstance_purposes
-- ----------------------------
ALTER TABLE "statement_circumstance_purposes" ADD CONSTRAINT "statement_logical_expression_uniq" UNIQUE ("statement_id", "logical_expression_id");

-- ----------------------------
-- Primary Key structure for table statement_circumstance_purposes
-- ----------------------------
ALTER TABLE "statement_circumstance_purposes" ADD CONSTRAINT "statement_circumstance_purpose_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table statements
-- ----------------------------
ALTER TABLE "statements" ADD CONSTRAINT "statement_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table associated_statements
-- ----------------------------
ALTER TABLE "associated_statements" ADD CONSTRAINT "semantic_id_fk" FOREIGN KEY ("semantic_id") REFERENCES "logical_expressions" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "associated_statements" ADD CONSTRAINT "source_id_fk" FOREIGN KEY ("source_id") REFERENCES "statements" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "associated_statements" ADD CONSTRAINT "target_id_fk" FOREIGN KEY ("target_id") REFERENCES "statements" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table measures
-- ----------------------------
ALTER TABLE "measures" ADD CONSTRAINT "semantic_id_fk" FOREIGN KEY ("semantic_id") REFERENCES "logical_expressions" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table participants
-- ----------------------------
ALTER TABLE "participants" ADD CONSTRAINT "code_id_fk" FOREIGN KEY ("code_id") REFERENCES "logical_expressions" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "participants" ADD CONSTRAINT "practitioner_id_fk" FOREIGN KEY ("practitioner_id") REFERENCES "practitioners" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table performance_circumstance_participants
-- ----------------------------
ALTER TABLE "performance_circumstance_participants" ADD CONSTRAINT "participant_id_fk" FOREIGN KEY ("participant_id") REFERENCES "participants" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "performance_circumstance_participants" ADD CONSTRAINT "performance_circumstance_id_fk" FOREIGN KEY ("performance_circumstance_id") REFERENCES "performance_circumstances" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table performance_circumstances
-- ----------------------------
ALTER TABLE "performance_circumstances" ADD CONSTRAINT "health_risk_id_fk" FOREIGN KEY ("health_risk_id") REFERENCES "logical_expressions" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "performance_circumstances" ADD CONSTRAINT "reference_range_id_fk" FOREIGN KEY ("reference_range_id") REFERENCES "measures" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "performance_circumstances" ADD CONSTRAINT "result_id_fk" FOREIGN KEY ("result_id") REFERENCES "measures" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "performance_circumstances" ADD CONSTRAINT "status_id_fk" FOREIGN KEY ("status_id") REFERENCES "logical_expressions" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table repetitions
-- ----------------------------
ALTER TABLE "repetitions" ADD CONSTRAINT "event_duration_id_fk" FOREIGN KEY ("event_duration_id") REFERENCES "measures" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "repetitions" ADD CONSTRAINT "event_frequency_id_fk" FOREIGN KEY ("event_frequency_id") REFERENCES "measures" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "repetitions" ADD CONSTRAINT "event_separation_id_fk" FOREIGN KEY ("event_separation_id") REFERENCES "measures" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "repetitions" ADD CONSTRAINT "period_duration_id_fk" FOREIGN KEY ("period_duration_id") REFERENCES "measures" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "repetitions" ADD CONSTRAINT "period_start_id_fk" FOREIGN KEY ("period_start_id") REFERENCES "measures" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table request_circumstance_associated_statements
-- ----------------------------
ALTER TABLE "request_circumstance_associated_statements" ADD CONSTRAINT "associated_statement_id_fk" FOREIGN KEY ("associated_statement_id") REFERENCES "associated_statements" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "request_circumstance_associated_statements" ADD CONSTRAINT "request_circumstance_id_fk" FOREIGN KEY ("request_circumstance_id") REFERENCES "request_circumstances" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table request_circumstance_participants
-- ----------------------------
ALTER TABLE "request_circumstance_participants" ADD CONSTRAINT "participant_id_fkey" FOREIGN KEY ("participant_id") REFERENCES "participants" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "request_circumstance_participants" ADD CONSTRAINT "request_circumstance_id_fkey" FOREIGN KEY ("request_circumstance_id") REFERENCES "request_circumstances" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table request_circumstances
-- ----------------------------
ALTER TABLE "request_circumstances" ADD CONSTRAINT "priority_id_fk" FOREIGN KEY ("priority_id") REFERENCES "logical_expressions" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "request_circumstances" ADD CONSTRAINT "repetition_id_fk" FOREIGN KEY ("repetition_id") REFERENCES "repetitions" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "request_circumstances" ADD CONSTRAINT "requested_result_id_fk" FOREIGN KEY ("requested_result_id") REFERENCES "measures" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table statement_authors
-- ----------------------------
ALTER TABLE "statement_authors" ADD CONSTRAINT "practitioner_id_fk" FOREIGN KEY ("practitioner_id") REFERENCES "practitioners" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "statement_authors" ADD CONSTRAINT "statement_id_fk" FOREIGN KEY ("statement_id") REFERENCES "statements" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table statement_circumstance_purposes
-- ----------------------------
ALTER TABLE "statement_circumstance_purposes" ADD CONSTRAINT "logical_expression_id_fk" FOREIGN KEY ("logical_expression_id") REFERENCES "logical_expressions" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "statement_circumstance_purposes" ADD CONSTRAINT "statement_id_fk" FOREIGN KEY ("statement_id") REFERENCES "statements" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table statements
-- ----------------------------
ALTER TABLE "statements" ADD CONSTRAINT "circumstance_timing_id_fk" FOREIGN KEY ("circumstance_timing_id") REFERENCES "measures" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "statements" ADD CONSTRAINT "subject_of_information_id_fk" FOREIGN KEY ("subject_of_information_id") REFERENCES "logical_expressions" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "statements" ADD CONSTRAINT "subject_of_record_id_fk" FOREIGN KEY ("subject_of_record_id") REFERENCES "participants" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "statements" ADD CONSTRAINT "time_id_fk" FOREIGN KEY ("time_id") REFERENCES "measures" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "statements" ADD CONSTRAINT "topic_id_fk" FOREIGN KEY ("topic_id") REFERENCES "logical_expressions" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "statements" ADD CONSTRAINT "type_id_fk" FOREIGN KEY ("type_id") REFERENCES "logical_expressions" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
