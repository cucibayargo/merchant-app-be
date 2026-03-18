--
-- PostgreSQL database dump
--

\restrict Et6mYEh92Tb7tBooFUn3ETmPkvq2l6J6cDEgLRZmkBaAtPw183JcDPierSAEzNb

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgsodium;


--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF EXISTS (
      SELECT 1
      FROM pg_event_trigger_ddl_commands() AS ev
      JOIN pg_extension AS ext
      ON ev.objid = ext.oid
      WHERE ext.extname = 'pg_net'
    )
    THEN
      IF NOT EXISTS (
        SELECT 1
        FROM pg_roles
        WHERE rolname = 'supabase_functions_admin'
      )
      THEN
        CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
      END IF;

      GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

      IF EXISTS (
        SELECT FROM pg_extension
        WHERE extname = 'pg_net'
        -- all versions in use on existing projects as of 2025-02-20
        -- version 0.12.0 onwards don't need these applied
        AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8.0', '0.10.0', '0.11.0')
      ) THEN
        ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
        ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

        ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
        ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

        REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
        REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

        GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
        GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      END IF;
    END IF;
  END;
  $$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- Name: generate_referral_code(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_referral_code(length integer DEFAULT 5) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; -- Excludes confusing chars
    result TEXT := '';
    i INT := 0;
BEGIN
    WHILE i < length LOOP
        result := result || substr(chars, (random() * length(chars) + 1)::INT, 1);
        i := i + 1;
    END LOOP;
    RETURN result;
END;
$$;


--
-- Name: set_order_for_transaction(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_order_for_transaction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Calculate the count of transactions for the same merchant_id
  NEW.order := (
    SELECT COUNT(*) + 1
    FROM transaction
    WHERE merchant_id = NEW.merchant_id
  );
  RETURN NEW;
END;
$$;


--
-- Name: transfer_referral_points_on_invoice_status(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.transfer_referral_points_on_invoice_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.status = 'diterima' AND OLD.status IS DISTINCT FROM 'diterima' THEN
        UPDATE users
        SET 
            referral_points_redeemed = COALESCE(referral_points_redeemed, 0) + COALESCE(referral_points_ingoing, 0),
            referral_points_ingoing = 0
        WHERE id = NEW.user_id;
    END IF;

    RETURN NULL;
END;
$$;


--
-- Name: update_user_referral_points(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_user_referral_points() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Add reward to both users
        UPDATE users
        SET referral_points = COALESCE(referral_points, 0) + COALESCE(NEW.referral_reward, 0)
        WHERE id IN (NEW.user_id, NEW.referred_user_id);

    ELSIF TG_OP = 'UPDATE' THEN
        -- Update reward for both users safely
        UPDATE users
        SET referral_points = GREATEST(
            COALESCE(referral_points, 0) 
            - COALESCE(OLD.referral_reward, 0)
            + COALESCE(NEW.referral_reward, 0), 
        0)
        WHERE id IN (NEW.user_id, NEW.referred_user_id);

    ELSIF TG_OP = 'DELETE' THEN
        -- Subtract reward but prevent going below zero
        UPDATE users
        SET referral_points = GREATEST(
            COALESCE(referral_points, 0) - COALESCE(OLD.referral_reward, 0),
        0)
        WHERE id IN (OLD.user_id, OLD.referred_user_id);
    END IF;

    RETURN NULL;
END;
$$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


--
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: -
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: app_invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_invoices (
    amount numeric,
    status character varying,
    due_date date,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    invoice_id character varying,
    plan_id uuid,
    user_id uuid,
    token text,
    referral_points_redeemed numeric DEFAULT 0
);


--
-- Name: app_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_plans (
    name character varying,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying NOT NULL,
    price double precision,
    duration integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: app_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_subscriptions (
    start_date date,
    end_date date,
    status character varying,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id uuid,
    plan_id uuid,
    user_plan_price double precision
);


--
-- Name: app_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id uuid,
    subscription_id uuid,
    amount numeric,
    transaction_date timestamp without time zone,
    payment_method character varying,
    status character varying,
    file character varying,
    note text,
    invoice_id character varying
);


--
-- Name: COLUMN app_transactions.file; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_transactions.file IS 'bukti transaksi';


--
-- Name: customer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer (
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    merchant_id uuid,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying,
    address character varying,
    phone_number character varying,
    email character varying,
    gender character varying
);


--
-- Name: discounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    merchant_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(20) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    value numeric,
    CONSTRAINT discounts_type_check CHECK (((type)::text = ANY ((ARRAY['percentage'::character varying, 'amount'::character varying])::text[])))
);


--
-- Name: duration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.duration (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    duration double precision,
    merchant_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    name character varying,
    type character varying
);


--
-- Name: expenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expenses (
    id bigint NOT NULL,
    merchant_id uuid NOT NULL,
    total numeric(14,2) NOT NULL,
    description text NOT NULL,
    date date NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.expenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.expenses_id_seq OWNED BY public.expenses.id;


--
-- Name: invoice_sequence; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoice_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.note (
    merchant_id uuid,
    notes text,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: offline_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offline_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone_number text,
    device_id text NOT NULL,
    device_model text
);


--
-- Name: password_resets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_resets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    reset_code character varying(10) NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    used_at timestamp without time zone,
    attempt_count integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: payment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment (
    merchant_id uuid,
    status character varying,
    invoice_id character varying,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    change_given double precision,
    total_amount_due double precision,
    payment_received double precision,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    transaction_id uuid,
    payment_method character varying(50)
);


--
-- Name: printed_devices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.printed_devices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    device_name character varying(255) NOT NULL,
    alias_name character varying(255),
    device_id character varying(255) NOT NULL,
    is_active boolean DEFAULT false,
    last_connected_at timestamp without time zone
);


--
-- Name: service; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    unit character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    merchant_id uuid,
    name character varying
);


--
-- Name: service_duration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_duration (
    service uuid DEFAULT gen_random_uuid() NOT NULL,
    price double precision NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    duration uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: transaction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transaction (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    customer_id uuid,
    completed_at timestamp without time zone,
    ready_to_pick_up_at timestamp without time zone,
    merchant_id uuid,
    customer_name character varying,
    customer_address text,
    status character varying,
    customer_email character varying,
    customer_phone_number character varying,
    "order" bigint,
    note text,
    deleted_at timestamp without time zone,
    discount_id uuid,
    discount_amount numeric(14,0) DEFAULT 0 NOT NULL
);


--
-- Name: transaction_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transaction_item (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    service_id uuid,
    qty double precision,
    service_unit character varying,
    transaction_id uuid,
    service_name character varying,
    price double precision,
    duration_id uuid,
    duration_name character varying(100),
    duration_length integer,
    duration_length_type character varying(50),
    estimated_date timestamp without time zone
);


--
-- Name: user_referral; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_referral (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id uuid,
    referred_user_id uuid,
    referral_reward numeric
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    token character varying,
    logo character varying,
    address character varying,
    password character varying,
    status character varying,
    oauth boolean,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying,
    email character varying,
    phone_number character varying,
    sequence_id integer NOT NULL,
    is_deleted boolean DEFAULT false,
    referral_points numeric DEFAULT 0,
    referral_points_redeemed numeric DEFAULT 0,
    referral_code character varying(255),
    referral_points_ingoing numeric DEFAULT 0
);


--
-- Name: users_sequence_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_sequence_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_sequence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_sequence_id_seq OWNED BY public.users.sequence_id;


--
-- Name: users_signup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_signup (
    name character varying,
    email character varying,
    phone_number character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    token character varying,
    status character varying,
    user_id uuid,
    subscription_plan uuid,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: decrypted_secrets; Type: VIEW; Schema: vault; Owner: -
--

CREATE VIEW vault.decrypted_secrets AS
 SELECT secrets.id,
    secrets.name,
    secrets.description,
    secrets.secret,
        CASE
            WHEN (secrets.secret IS NULL) THEN NULL::text
            ELSE
            CASE
                WHEN (secrets.key_id IS NULL) THEN NULL::text
                ELSE convert_from(pgsodium.crypto_aead_det_decrypt(decode(secrets.secret, 'base64'::text), convert_to(((((secrets.id)::text || secrets.description) || (secrets.created_at)::text) || (secrets.updated_at)::text), 'utf8'::name), secrets.key_id, secrets.nonce), 'utf8'::name)
            END
        END AS decrypted_secret,
    secrets.key_id,
    secrets.nonce,
    secrets.created_at,
    secrets.updated_at
   FROM vault.secrets;


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses ALTER COLUMN id SET DEFAULT nextval('public.expenses_id_seq'::regclass);


--
-- Name: users sequence_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN sequence_id SET DEFAULT nextval('public.users_sequence_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: -
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: app_invoices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_invoices (amount, status, due_date, id, created_at, invoice_id, plan_id, user_id, token, referral_points_redeemed) FROM stdin;
39000	Kedaluarsa	\N	ed0fadbf-365f-4ca5-9003-99de897adb36	2025-02-23 17:00:19.032999+00	CBG-1740330018965	8b1abc6b-f501-4d0b-99a0-913886ff9e98	e9bec3fe-766c-41fe-a144-fcb73d705e95	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFyaWZyYW1kaGFuODMxQGdtYWlsLmNvbSIsImlhdCI6MTc0MDMzMDAxNiwiZXhwIjoxNzQwOTM0ODE2fQ.ppM9-txepC1lT6Au_r0BH3vBYpKFdpy0ZOwYWPIPTpA	0
39000	Diterima	\N	1e295a02-2abe-4b92-a5c0-9195fd923477	2024-12-23 19:40:55.502715+00	CBG-1734982855486	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
39000	Ditolak	\N	e857bc00-95d3-432d-8d56-7949f4ceaac6	2024-12-24 17:52:54.018993+00	CBG-1735062774058	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
45000	Diterima	2026-03-02	86010e33-eaa3-4d61-a3a0-a5eb0d0d8ffa	2026-02-27 15:30:38.702938+00	CBG-1772206238635	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
125000	Diterima	2026-03-02	402d5f3e-6807-429f-b9bc-d6997b32f9fb	2026-02-27 15:44:34.384181+00	CBG-1772207074312	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	5000
0	Kedaluarsa	\N	6572fcd5-0f76-4f6e-83ef-2823be0e6f49	2025-02-23 17:00:19.085039+00	CBG-1740330019013	eae03b60-99e9-49da-9878-4006c2f2c7df	361333db-632e-44b4-9192-7f4861046172	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNhaWZ1bG11aGFtbWFkNDE0QGdtYWlsLmNvbSIsImlhdCI6MTc0MDMzMDAxNiwiZXhwIjoxNzQwOTM0ODE2fQ.hw0BckOSzLUUgX9VetlHoh6nvmYiosxvNCEfow0kpXI	0
45000	Ditolak	2026-03-02	500af944-7585-4ab1-81a7-ac5dc7a666a4	2026-02-27 15:47:04.150552+00	CBG-1772207224080	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
0	Kedaluarsa	\N	290e37e7-8a2c-40a4-a856-3b40250b4d86	2024-12-24 17:53:49.310032+00	CBG-1735062829346	eae03b60-99e9-49da-9878-4006c2f2c7df	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
530000	Kedaluarsa	2026-03-04	98bf91e9-4213-443d-aaec-85960169fb4e	2026-03-01 23:30:15.048037+00	CBG-1772407814982	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
0	Kedaluarsa	\N	13e29afa-483b-4c65-ba34-39e0410e2a0f	2025-02-16 13:38:13.671844+00	CBG-1739713093612	eae03b60-99e9-49da-9878-4006c2f2c7df	cc3d67d9-aafd-41b4-93e6-c00b588ec078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImthcHN1bG5vdGVAZ21haWwuY29tIiwiaWF0IjoxNzM5NzEzMDkxLCJleHAiOjE3NDAzMTc4OTF9.UDmn4DrjUQ31B8I9Kp6NQBit_gIaSpMH2XEKw2lKUZs	0
39000	Kedaluarsa	\N	e3b3c3da-95c0-4b12-980f-6da03d47253f	2025-01-11 15:55:27.175371+00	CBG-1736610927153	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
45000	Kedaluarsa	2026-03-04	c295cba5-f099-42a7-b2c8-b8c743083714	2026-03-01 07:59:56.01995+00	CBG-1772351995912	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
0	Diterima	2026-03-05	ee4b606d-67c6-4345-abaf-4554749476cc	2026-03-02 17:00:21.376125+00	CBG-1772470821300	eae03b60-99e9-49da-9878-4006c2f2c7df	65e7caf4-1316-49da-a3b9-3b7f8fef3955	\N	0
0	Diterima	2026-03-05	b1805005-eab6-4571-a4ea-778716fd4669	2026-03-02 17:00:21.387993+00	CBG-1772470821321	eae03b60-99e9-49da-9878-4006c2f2c7df	6e56ab91-182b-4f44-b226-d1f0dc289423	\N	0
39000	Diterima	\N	c9236ad0-d557-4c02-94fa-4928e146041c	2025-04-27 12:44:34.089371+00	CBG-1745757874007	8b1abc6b-f501-4d0b-99a0-913886ff9e98	d73cfd09-e4ca-415d-880b-d5944c8a04df	b56832932958a263123bbab51662377d7a63dc1e51e90d6721277a2cc50623d1	0
125000	Diterima	\N	f0b153c9-fc9c-48b3-a60d-c64a93164795	2025-05-01 14:44:44.01889+00	CBG-1746110683914	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	22134a8f11a342c7689af2b4884a940dfb60dd198e488a3c8899222c440172a3	0
125000	Diterima	\N	91cf29c6-6b8b-4ea4-a5ce-b8f0fe245428	2025-05-01 14:48:09.211317+00	CBG-1746110889107	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	22134a8f11a342c7689af2b4884a940dfb60dd198e488a3c8899222c440172a3	0
125000	Diterima	\N	0e11d53a-c3f2-4c57-b8dc-6d1c6f1da97f	2025-05-01 15:07:25.334293+00	CBG-1746112045250	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	8be70116-5bc2-4a51-a3b5-5001739899ae	22134a8f11a342c7689af2b4884a940dfb60dd198e488a3c8899222c440172a3	0
530000	Diterima	\N	c1e359ee-c93f-4373-9d53-498f1cf816db	2025-05-21 03:00:59.002012+00	CBG-1747796458942	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	490e65e1-0159-4a63-855c-b3ed8e621ef4	62258a32d91072fc007b9c2f44564f4181aa2c3cca4a454f077f396a34f2c637	0
0	Kedaluarsa	\N	2438e191-2a47-4da5-b466-5638998e854f	2025-03-23 03:34:54.316667+00	CBG-1742700894247	eae03b60-99e9-49da-9878-4006c2f2c7df	6604cebe-ece2-42dd-80de-f4cd5e8fb559	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJhdGVjYWg2OTBAZXhjZWRlcm0uY29tIiwiaWF0IjoxNzQyNzAwODkyLCJleHAiOjE3NDMzMDU2OTJ9.7MxlTgVpthzCP4uLHMe6-Z8UvCj9fr4Xwn6tFy9k2lk	0
39000	Diterima	\N	027385ef-0c4f-43f4-895a-8e197fcc816f	2025-02-23 07:26:56.261071+00	CBG-1740295616170	8b1abc6b-f501-4d0b-99a0-913886ff9e98	e9bec3fe-766c-41fe-a144-fcb73d705e95	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFyaWZyYW1kaGFuODMxQGdtYWlsLmNvbSIsImlhdCI6MTc0MDI5NTYxNCwiZXhwIjoxNzQwOTAwNDE0fQ.g0KNkbS1l-aeN65gagyJJY0LNwr7zeELx4xolgAqqLs	0
125000	Diterima	\N	614b69c3-a9d6-4d9e-923c-b635db16f385	2025-06-14 11:30:20.670746+00	CBG-1749900620604	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	5f892fcb-c56a-4059-ba66-e581e45e3a67	\N	0
125000	Kedaluarsa	\N	1b8b1cb3-b2db-437d-ba17-3c098109127e	2025-06-14 11:16:09.583885+00	CBG-1749899769522	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	704b9e26-e5ce-4f92-9b5d-ded4eecace01	\N	0
0	Diterima	\N	9d610e17-2d1d-489e-815b-12f0e1da8566	2025-07-07 15:55:46.445113+00	CBG-1751903745962	8b1abc6b-f501-4d0b-99a0-913886ff9e98	7e214247-26dc-49cc-af5e-48926de89be6	\N	0
0	Diterima	\N	c1ce0faa-4b4a-49bc-aeb1-e4eb18398ce9	2025-07-07 15:57:48.838475+00	CBG-1751903868354	8b1abc6b-f501-4d0b-99a0-913886ff9e98	1c5e12f4-a59a-4838-83cc-bf399f5b9221	\N	0
0	Diterima	2025-07-10	bac4a461-211d-468d-8c83-bf1eb9f46c28	2025-07-07 16:03:08.337896+00	CBG-1751904187846	8b1abc6b-f501-4d0b-99a0-913886ff9e98	a7d92f73-5755-49a1-971c-5e14c1d47a31	\N	0
45000	Kedaluarsa	2026-03-04	aa10a5de-3409-491c-aaf4-61326e9adbd2	2026-03-01 08:10:49.376141+00	CBG-1772352649249	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
45000	Kedaluarsa	2026-03-04	0503af99-f175-4017-8e21-fe17db3c5448	2026-03-01 08:12:06.644415+00	CBG-1772352726577	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
0	Diterima	2026-03-05	7c99ec9f-9a54-4ef7-b425-3d0552718e9f	2026-03-02 17:00:21.592402+00	CBG-1772470821524	eae03b60-99e9-49da-9878-4006c2f2c7df	579c0264-e4bf-4cac-881d-2d3aa5fff59d	\N	0
0	Diterima	2026-03-05	2f905e5e-3907-4553-bac0-71c130fd4e97	2026-03-02 17:00:21.624976+00	CBG-1772470821549	eae03b60-99e9-49da-9878-4006c2f2c7df	8d468ffc-f533-48ba-8c6b-285d63647a99	\N	0
0	Diterima	2025-07-24	7e5f209f-19fb-49fe-95e6-c63023094570	2025-07-21 17:00:21.832408+00	CBG-1753117221733	eae03b60-99e9-49da-9878-4006c2f2c7df	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	\N	0
0	Diterima	2025-07-24	7ca707e3-bf92-4440-a1e4-bda66acca5ce	2025-07-21 17:00:21.867917+00	CBG-1753117221767	eae03b60-99e9-49da-9878-4006c2f2c7df	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	\N	0
0	Diterima	2025-07-16	a1c5d06c-f9b3-4df7-b314-3d7e997430d6	2025-07-13 07:23:37.657074+00	CBG-1752391417589	8b1abc6b-f501-4d0b-99a0-913886ff9e98	18184643-ccb7-4f42-aa82-d423445bcf3d	\N	0
0	Diterima	2025-07-24	a26183e3-d2b5-484c-97de-735683c56beb	2025-07-21 17:00:21.899478+00	CBG-1753117221799	eae03b60-99e9-49da-9878-4006c2f2c7df	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	\N	0
45000	Kedaluarsa	\N	63e9cd19-d466-4a54-9d0e-50119a0961e7	2025-06-15 12:21:35.52643+00	CBG-1749990095454	8b1abc6b-f501-4d0b-99a0-913886ff9e98	eea90897-1470-4ff5-a32d-cabb71375c9e	\N	0
0	Diterima	2025-08-17	3f260286-6087-444b-b5f2-5ac3aa3b9db0	2025-08-14 17:00:17.358394+00	CBG-1755190817285	eae03b60-99e9-49da-9878-4006c2f2c7df	d9453749-87fb-469d-a93a-22a577b0e98b	\N	0
0	Diterima	2025-08-24	7b6f204d-1257-42e0-8578-5f52d7ffb4f3	2025-08-21 17:00:17.627637+00	CBG-1755795617542	eae03b60-99e9-49da-9878-4006c2f2c7df	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	\N	0
0	Diterima	2025-09-07	4f39ec11-ce2e-4da8-8325-d8ff95594d3f	2025-09-04 17:00:17.422412+00	CBG-1757005217355	eae03b60-99e9-49da-9878-4006c2f2c7df	fe4e3388-40d9-422a-8140-a5a21ab56fbb	\N	0
0	Diterima	2025-09-21	3a7e13d6-c293-4273-90d7-30e6985b8823	2025-09-18 17:00:17.34137+00	CBG-1758214817218	eae03b60-99e9-49da-9878-4006c2f2c7df	7aefc064-bbad-40cc-b31e-645c90c9116c	\N	0
0	Diterima	2025-11-13	e0f495d5-47be-43ac-afac-e8b4f45276c0	2025-11-10 14:31:43.249421+00	CBG-1762785103143	8b1abc6b-f501-4d0b-99a0-913886ff9e98	83731f63-30af-4793-be22-43d9b622e7d4	\N	0
125000	Kedaluarsa	\N	a28b7807-ce1f-4926-86b3-788488978658	2025-06-15 13:01:09.394472+00	CBG-1749992469321	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	\N	0
0	Diterima	2025-07-23	192e8ba2-e5be-49ce-93ca-7b12e73755c0	2025-07-20 03:20:16.26375+00	CBG-1752981616154	8b1abc6b-f501-4d0b-99a0-913886ff9e98	e128e7f5-d6b1-4895-98d0-84583540da63	\N	0
0	Diterima	2025-11-22	6dfe96a7-9784-4452-a5b6-41ffded86f81	2025-11-19 17:00:17.506398+00	CBG-1763571617396	eae03b60-99e9-49da-9878-4006c2f2c7df	9e9f89b7-0659-411f-b06d-d75bff0eb648	\N	0
0	Diterima	2025-11-24	7b50561b-e976-49d3-9949-39bc2cae2311	2025-11-21 17:00:18.061521+00	CBG-1763744417950	eae03b60-99e9-49da-9878-4006c2f2c7df	6fed4540-3689-4ee4-837d-614174568f7d	\N	0
0	Kedaluarsa	\N	b171aa95-0be7-4b31-9700-6083fa81faa7	2025-06-23 17:00:19.186046+00	CBG-1750698019127	eae03b60-99e9-49da-9878-4006c2f2c7df	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	\N	0
45000	Diterima	2025-12-29	6da631c8-3d32-42d8-94ff-329d6a7fd24f	2025-12-26 02:01:09.630557+00	CBG-1766714469587	8b1abc6b-f501-4d0b-99a0-913886ff9e98	20a1b60b-2c45-4533-a02e-ad9d4545b860	\N	0
0	Kedaluarsa	\N	c6b0001d-2aec-4a64-bae1-ffd3c72f6b42	2025-06-23 17:00:19.183153+00	CBG-1750698019126	eae03b60-99e9-49da-9878-4006c2f2c7df	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	\N	0
0	Kedaluarsa	\N	de471cd9-09a3-485c-8565-d430f9e575a4	2025-06-24 17:00:20.606365+00	CBG-1750784420550	eae03b60-99e9-49da-9878-4006c2f2c7df	ddc18a20-f5e5-48d3-a94d-9febac756a86	\N	0
0	Diterima	2025-12-26	a64b6b5a-f4cf-4bd8-acc1-a59a7b318900	2025-12-23 13:50:26.912837+00	CBG-1766497826848	eae03b60-99e9-49da-9878-4006c2f2c7df	8db3f967-5f09-4150-a95b-010faa31a22a	\N	0
0	Diterima	2026-01-08	fd4c6031-f6c1-40d2-9f08-ce0a876f155d	2026-01-05 17:00:19.256225+00	CBG-1767632419145	eae03b60-99e9-49da-9878-4006c2f2c7df	8db3f967-5f09-4150-a95b-010faa31a22a	\N	0
0	Kedaluarsa	\N	699a686b-2da9-4999-aa84-c3dc802d3689	2025-06-24 17:00:20.642236+00	CBG-1750784420587	eae03b60-99e9-49da-9878-4006c2f2c7df	1ad21901-807d-4aa4-80d4-640876d4faab	\N	0
0	Kedaluarsa	\N	1c82ad63-1ad8-4adf-b454-0670689b8170	2025-06-24 17:00:20.646876+00	CBG-1750784420591	eae03b60-99e9-49da-9878-4006c2f2c7df	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	\N	0
0	Kedaluarsa	\N	8cfefc94-5fa3-4c8f-ac36-0485cc55297c	2025-06-24 17:00:20.681142+00	CBG-1750784420618	eae03b60-99e9-49da-9878-4006c2f2c7df	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	\N	0
0	Kedaluarsa	\N	d6e97d03-6434-49f4-b0d1-33df073021b4	2025-06-25 17:00:19.240067+00	CBG-1750870819176	eae03b60-99e9-49da-9878-4006c2f2c7df	b54508fb-9003-4919-93e3-096d0b87f9a8	\N	0
0	Kedaluarsa	2025-07-11	b69ec2fe-823f-49e9-96c5-46d11f25638d	2025-07-08 17:10:47.990101+00	CBG-1751994647459	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
25000	Kedaluarsa	\N	5a877298-08ee-4c98-a0c3-05a4cbede454	2025-07-07 15:53:35.394227+00	CBG-1751903614912	8b1abc6b-f501-4d0b-99a0-913886ff9e98	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	\N	0
125000	Kedaluarsa	2026-03-02	02359eed-5416-4f4b-bf0e-f065f45a0d3f	2026-02-27 14:59:38.52843+00	CBG-1772204378405	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
530000	Kedaluarsa	2026-03-02	555674d9-95d1-4894-92f6-678ed62e93bc	2026-02-27 15:16:53.39225+00	CBG-1772205413296	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
530000	Kedaluarsa	2026-03-02	88e95a33-8d8f-4957-9912-9289b78f172f	2026-02-27 15:18:07.99239+00	CBG-1772205487899	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
530000	Kedaluarsa	2026-03-02	902b4422-c559-445a-abe5-8665625cfe9c	2026-02-27 15:14:03.887611+00	CBG-1772205243793	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	125000
530000	Kedaluarsa	2026-03-02	5a868d6d-e676-465a-96a6-d81158dcf3ee	2026-02-27 15:18:29.640803+00	CBG-1772205509549	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
530000	Diterima	2026-03-02	a7114044-cebd-4611-a851-d3e62c04bc12	2026-02-27 15:19:10.408128+00	CBG-1772205550316	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	125000
0	Kedaluarsa	\N	280ef009-5a07-42e3-821c-c7cccd2bea45	2025-02-22 17:00:19.741717+00	CBG-1740243619667	eae03b60-99e9-49da-9878-4006c2f2c7df	d9c0bf10-e555-4a6f-afa8-ec012d641035	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImhvdGVmYXY3NDRAcHJvcnNkLmNvbSIsImlhdCI6MTc0MDI0MzYxNywiZXhwIjoxNzQwODQ4NDE3fQ.-IP4aeLtIpVRVhQYql51YfhBKuEEifFFe_N0LGS9AiE	0
0	Kedaluarsa	\N	d6a6728b-292d-4fd0-b5b3-ee95c1140b16	2024-12-24 17:56:36.949376+00	CBG-1735062996984	eae03b60-99e9-49da-9878-4006c2f2c7df	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
39000	Kedaluarsa	\N	6cb8a2e8-f86b-46e2-93da-04c0fa655ea9	2024-12-25 02:12:46.536454+00	CBG-1735092766509	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
0	Kedaluarsa	\N	c0ae2fd8-8abb-4fcd-afa2-973834590808	2025-02-23 07:26:56.289825+00	CBG-1740295616196	eae03b60-99e9-49da-9878-4006c2f2c7df	361333db-632e-44b4-9192-7f4861046172	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNhaWZ1bG11aGFtbWFkNDE0QGdtYWlsLmNvbSIsImlhdCI6MTc0MDI5NTYxNCwiZXhwIjoxNzQwOTAwNDE0fQ.7-UgDQH5OUJ-yielDOgzq8mZHp3HPJNDFCwpwAXDn10	0
45000	Kedaluarsa	2025-07-19	df719361-3444-4cbc-8e93-58de74b0af91	2025-07-16 15:53:43.222323+00	CBG-1752681222809	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
45000	Kedaluarsa	2026-01-01	341944f6-6f50-492a-b2c3-a1885e236b66	2025-12-29 14:02:53.612138+00	CBG-1767016973543	8b1abc6b-f501-4d0b-99a0-913886ff9e98	ba472db5-f09a-48c3-b6c9-e3233acfc46f	\N	0
0	Kedaluarsa	2025-10-05	7894a922-5a72-4597-9554-53c359dd5e9b	2025-10-02 17:00:16.576952+00	CBG-1759424416504	eae03b60-99e9-49da-9878-4006c2f2c7df	8db3f967-5f09-4150-a95b-010faa31a22a	\N	0
260000	Kedaluarsa	2026-01-01	67a7fa6f-d188-4bf7-b607-98f468b158eb	2025-12-29 14:04:58.806248+00	CBG-1767017098741	6c43c4ed-1625-441c-af43-feb446b7f7b1	3d54010f-5655-4c05-bed1-4984d5347c93	\N	0
45000	Kedaluarsa	2025-07-19	863fd85a-9648-4359-a86c-c67112da4d57	2025-07-16 17:00:19.203349+00	CBG-1752685219130	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
45000	Kedaluarsa	2026-03-02	b062b571-0c0e-4735-9770-b4169bbeb8f0	2026-02-27 14:24:19.605221+00	CBG-1772202259430	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
45000	Kedaluarsa	2026-03-02	f496568d-10b9-4396-a43b-d764d53dc20b	2026-02-27 14:30:17.829769+00	CBG-1772202617667	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
45000	Kedaluarsa	2026-03-02	b6156474-6c41-40e7-9941-f1557bd396a7	2026-02-27 14:31:45.217633+00	CBG-1772202705052	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
45000	Kedaluarsa	2026-03-02	1bb76727-6eff-4d88-b1d3-04f901e9b576	2026-02-27 14:34:22.429817+00	CBG-1772202862259	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
45000	Kedaluarsa	2026-03-02	69c9b1da-a877-4fe5-bd08-0b1d50d2b57b	2026-02-27 14:34:32.78784+00	CBG-1772202872619	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
125000	Kedaluarsa	2026-03-02	72185d76-0a2b-4203-843a-9b3c0f409d54	2026-02-27 14:35:09.120468+00	CBG-1772202908953	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
125000	Kedaluarsa	2026-03-02	02c92b00-c99d-4169-bf89-5b4ca9a43f2c	2026-02-27 14:42:11.998617+00	CBG-1772203331842	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
39000	Kedaluarsa	\N	9ec71953-a878-411e-b674-b092a6dd6de2	2025-01-11 16:08:42.502002+00	CBG-1736611722475	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
39000	Kedaluarsa	\N	7917d3ba-ff58-49e6-9570-ff20c054fddd	2025-01-11 16:11:42.424361+00	CBG-1736611902282	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
39000	Kedaluarsa	\N	066557d7-4955-4cb9-8976-153d84c8e327	2025-02-23 02:28:32.52988+00	CBG-1740277712415	8b1abc6b-f501-4d0b-99a0-913886ff9e98	7aefc064-bbad-40cc-b31e-645c90c9116c	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFyaWZyYW1kaGFuODMxQGdtYWlsLmNvbSIsImlhdCI6MTc0MDI3NzcxMCwiZXhwIjoxNzQwODgyNTEwfQ.ZTfkhQE-76m3OaU9avjXwcikM5ap5zaZ-UsZxw4S9qM	0
0	Kedaluarsa	\N	f3bbab19-45a9-4385-aa28-fa4061a5a94b	2025-03-04 17:00:19.441436+00	CBG-1741107619372	eae03b60-99e9-49da-9878-4006c2f2c7df	cc996432-8af0-4d72-9dd8-022ee19ff6e1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJlbmlsb3c4NzRAbm9vbWxvY3MuY29tIiwiaWF0IjoxNzQxMTA3NjE3LCJleHAiOjE3NDE3MTI0MTd9.aLpskW54mjxW9yUouXCHKZdaqFeXpl39EKHXqYPnC7A	0
0	Kedaluarsa	\N	f0487cb0-9bca-4090-ad85-dad5e819a59a	2025-03-13 17:00:18.126557+00	CBG-1741885218057	eae03b60-99e9-49da-9878-4006c2f2c7df	ca3cb819-ec42-4b13-883e-e3131abe9bb2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImxlZ2F0b3Y1NzNAaGFydGFyaWEuY29tIiwiaWF0IjoxNzQxODg1MjE1LCJleHAiOjE3NDI0OTAwMTV9.jpMJIs7RxmXjXXvKH6a3090TEpzhgPUXAl5aBMTudJs	0
125000	Diterima	2026-03-02	b1323b1a-ec68-4cad-b455-f1662c566660	2026-02-27 14:42:23.540598+00	CBG-1772203343419	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	45000
39000	Kedaluarsa	\N	bc88f277-f0cf-458c-acec-d0b196e08d0e	2025-01-11 17:00:16.569417+00	CBG-1736614816461	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
39000	Kedaluarsa	\N	09edb6ad-e8be-4011-a116-b5072a86595f	2025-03-16 17:00:18.962905+00	CBG-1742144418867	8b1abc6b-f501-4d0b-99a0-913886ff9e98	cc3d67d9-aafd-41b4-93e6-c00b588ec078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImthcHN1bG5vdGVAZ21haWwuY29tIiwiaWF0IjoxNzQyMTQ0NDE2LCJleHAiOjE3NDI3NDkyMTZ9.O446O8H9i-T6kfhI55ne2nDun3_bZjTHUuJiAGKBho0	0
39000	Kedaluarsa	\N	6ba0e611-66de-4e84-98e1-73534d64b9b0	2025-01-19 02:08:11.933408+00	CBG-1737252491912	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
39000	Kedaluarsa	\N	57d6c178-d23c-4948-9b47-24e912c9aecc	2025-01-19 02:10:24.35907+00	CBG-1737252624344	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	\N	0
39000	Kedaluarsa	\N	7b182d10-6030-4d58-a749-6e56416126e1	2025-01-19 14:42:06.658357+00	CBG-1737297726734	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IndlZGFuZ2NvZGUudGVhbUBnbWFpbC5jb20iLCJpYXQiOjE3MzcyOTc3MjYsImV4cCI6MTczNzkwMjUyNn0.1crMf_DjZCPNFnJLFlztdjMQ6Tf9hAUPIhDM4QUtbS8	0
39000	Kedaluarsa	\N	fee23689-c2a6-4da8-aa44-d510a90775f6	2025-01-19 17:00:16.654072+00	CBG-1737306016530	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IndlZGFuZ2NvZGUudGVhbUBnbWFpbC5jb20iLCJpYXQiOjE3MzczMDYwMTQsImV4cCI6MTczNzkxMDgxNH0.L8nESX9JS-Rewjo9vdNEUNMN7ylWBA7ZGRgCvD1UEK8	0
0	Diterima	2026-03-06	fe15b149-4988-434b-82d2-d19b741127bb	2026-03-03 17:00:20.97009+00	CBG-1772557220868	eae03b60-99e9-49da-9878-4006c2f2c7df	cf7cfef7-6850-46c2-9efc-22c28cb0922c	\N	0
39000	Kedaluarsa	\N	c38a463b-7a51-4afa-91c8-8840239eae48	2025-01-20 14:04:54.681064+00	CBG-1737381894569	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IndlZGFuZ2NvZGUudGVhbUBnbWFpbC5jb20iLCJpYXQiOjE3MzczODE4OTIsImV4cCI6MTczNzk4NjY5Mn0.hL6nRL3VavyypzBlm5mMMIw3iRIsYwcJzzi_npwYtUY	0
39000	Kedaluarsa	\N	1445c6df-9c69-4cbc-ba94-6f37687d2236	2025-01-20 17:00:18.126432+00	CBG-1737392418019	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IndlZGFuZ2NvZGUudGVhbUBnbWFpbC5jb20iLCJpYXQiOjE3MzczOTI0MTUsImV4cCI6MTczNzk5NzIxNX0.8Yq-kQEkml-fU3iagUi9XxUarcTYWih0mqdHtfFprSQ	0
45000	Kedaluarsa	2026-03-04	a4b805a5-45d6-4fbb-b2f0-5ba5e3784216	2026-03-01 08:13:36.850844+00	CBG-1772352816782	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
45000	Kedaluarsa	2026-03-04	93b84071-1e41-4088-9312-b3c05b70b405	2026-03-01 08:14:00.327765+00	CBG-1772352840260	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
45000	Kedaluarsa	2026-03-04	b52dee0e-cb0d-48c8-96f1-e2739e670a4a	2026-03-01 08:17:27.731635+00	CBG-1772353047661	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
0	Kedaluarsa	\N	c76563ec-5300-40da-8213-841c4b5fadbe	2025-02-03 17:00:17.02272+00	CBG-1738602016897	eae03b60-99e9-49da-9878-4006c2f2c7df	cc3d67d9-aafd-41b4-93e6-c00b588ec078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImthcHN1bG5vdGVAZ21haWwuY29tIiwiaWF0IjoxNzM4NjAyMDE0LCJleHAiOjE3MzkyMDY4MTR9.G6qVRW2vEbVxmIYlexxHeHzTtXAO9iTUEjA-nI0XKPQ	0
0	Kedaluarsa	\N	43113031-e0bf-4a56-a00a-ce9cfc850127	2025-02-15 17:00:19.818521+00	CBG-1739638819725	eae03b60-99e9-49da-9878-4006c2f2c7df	cc3d67d9-aafd-41b4-93e6-c00b588ec078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImthcHN1bG5vdGVAZ21haWwuY29tIiwiaWF0IjoxNzM5NjM4ODE3LCJleHAiOjE3NDAyNDM2MTd9.wQHxhoj4H8hq7Vt_1CQfgM-jb9M22cNKLU0Vec9w8_k	0
39000	Kedaluarsa	\N	83b46deb-39c8-4b9c-bbba-23e2f3077ae0	2025-02-16 02:54:03.262759+00	CBG-1739674443178	8b1abc6b-f501-4d0b-99a0-913886ff9e98	e9bec3fe-766c-41fe-a144-fcb73d705e95	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFyaWZyYW1kaGFuODMxQGdtYWlsLmNvbSIsImlhdCI6MTczOTY3NDQ0MSwiZXhwIjoxNzQwMjc5MjQxfQ.KIpDGrPOKNU8mluTEQYqLTCDiDYaeHfSONgyesle9Hs	0
0	Kedaluarsa	\N	f2b8ce04-809e-4044-a46a-81d904530461	2025-03-18 17:00:21.416124+00	CBG-1742317221357	eae03b60-99e9-49da-9878-4006c2f2c7df	aea1e62f-72db-4b8a-af7e-1d72bd34665b	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImxvZmlqODYxOTBAa2FpYXYuY29tIiwiaWF0IjoxNzQyMzE3MjE5LCJleHAiOjE3NDI5MjIwMTl9.T94OySrqpOMn55aBg0J7S_BcvBjd7MeyCxBXk1rVw7o	0
0	Kedaluarsa	\N	2ffb22b6-7a94-4543-9b7d-837d192a470b	2025-03-23 03:32:18.13855+00	CBG-1742700738066	eae03b60-99e9-49da-9878-4006c2f2c7df	6604cebe-ece2-42dd-80de-f4cd5e8fb559	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJhdGVjYWg2OTBAZXhjZWRlcm0uY29tIiwiaWF0IjoxNzQyNzAwNzM1LCJleHAiOjE3NDMzMDU1MzV9.ge8Km0AkbhCbDRcd_9Sit1DaoEJJcFRZV_vsPXWss2g	0
0	Kedaluarsa	\N	766c2816-6e0c-4141-9961-6f7406d6b353	2025-03-23 03:33:08.292497+00	CBG-1742700788214	eae03b60-99e9-49da-9878-4006c2f2c7df	6604cebe-ece2-42dd-80de-f4cd5e8fb559	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJhdGVjYWg2OTBAZXhjZWRlcm0uY29tIiwiaWF0IjoxNzQyNzAwNzg1LCJleHAiOjE3NDMzMDU1ODV9.oV2n4Flzo3qCtBvNYc7uMc3xL5OY1-xvtzuOasCF7vo	0
39000	Kedaluarsa	\N	829a6f56-6d1e-425d-8b55-9eee9947e88a	2025-03-23 03:34:54.347002+00	CBG-1742700894272	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IndlZGFuZ2NvZGUudGVhbUBnbWFpbC5jb20iLCJpYXQiOjE3NDI3MDA4OTIsImV4cCI6MTc0MzMwNTY5Mn0.cIJAJlPFoTcjZlOQLi9bWMeqy9jldqGwXilhF53DGKM	0
0	Kedaluarsa	\N	9d73a9bd-48f7-4a06-a905-fa2a25eed00d	2025-03-23 03:58:18.117164+00	CBG-1742702298047	eae03b60-99e9-49da-9878-4006c2f2c7df	6604cebe-ece2-42dd-80de-f4cd5e8fb559	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJhdGVjYWg2OTBAZXhjZWRlcm0uY29tIiwiaWF0IjoxNzQyNzAyMjk1LCJleHAiOjE3NDMzMDcwOTV9.S42eLT8qvHWlqIjA9dH9TxWypVzxVp6Vp61OiBZz6x4	0
39000	Kedaluarsa	\N	e68a1151-83c6-4c1e-966a-b30321db5153	2025-03-23 03:58:18.146721+00	CBG-1742702298074	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IndlZGFuZ2NvZGUudGVhbUBnbWFpbC5jb20iLCJpYXQiOjE3NDI3MDIyOTUsImV4cCI6MTc0MzMwNzA5NX0.X-xBVp24dXfASmdytBR39uR66OzYCClB_3rplk1nUcw	0
39000	Kedaluarsa	\N	74988a5f-0e55-4729-92ee-5984f4e27452	2025-03-23 04:02:29.423725+00	CBG-1742702549346	8b1abc6b-f501-4d0b-99a0-913886ff9e98	a2eed2f1-b740-4512-8d71-368c2df49c59	53287bc2264acf3c3f7f5cdfe559b08f927b7a6965876f9241537401e961efab	0
0	Kedaluarsa	\N	ebf3bc57-ab00-4c04-ab9c-d7bca84d32da	2025-03-23 17:00:19.179679+00	CBG-1742749219117	eae03b60-99e9-49da-9878-4006c2f2c7df	6604cebe-ece2-42dd-80de-f4cd5e8fb559	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJhdGVjYWg2OTBAZXhjZWRlcm0uY29tIiwiaWF0IjoxNzQyNzQ5MjE2LCJleHAiOjE3NDMzNTQwMTZ9.t0MUIhvKmQjM3FKPqMJNEgKFUaQUivzxjEypJpnssa8	0
39000	Kedaluarsa	\N	e20a3136-b616-4360-b595-13bc5edf8bdf	2025-03-23 17:00:19.249575+00	CBG-1742749219183	8b1abc6b-f501-4d0b-99a0-913886ff9e98	99eea1df-1d39-4fae-a8ca-65e71349b34c	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IndlZGFuZ2NvZGUudGVhbUBnbWFpbC5jb20iLCJpYXQiOjE3NDI3NDkyMTYsImV4cCI6MTc0MzM1NDAxNn0.zVczqNhm683fwo3-8ZS4FlYsBYgtlL2eBNAlrpcb3QM	0
0	Kedaluarsa	\N	cf8fb712-5d36-4e11-b4b9-5fff593c1cae	2025-03-25 17:00:19.32072+00	CBG-1742922019241	eae03b60-99e9-49da-9878-4006c2f2c7df	85239af0-2860-4e35-9f6f-5aa79a10ceb7	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im11aGFtbWFkLnNhaWZ1bC5lbmdpbmVlckBnbWFpbC5jb20iLCJpYXQiOjE3NDI5MjIwMTYsImV4cCI6MTc0MzUyNjgxNn0.8Rjm_5-QUM8C44YFA_ZZCQhXRbfdFQXIwNfouf5vxow	0
0	Kedaluarsa	\N	60edd349-81f8-4ef6-8382-3df141074465	2025-03-25 17:00:19.34381+00	CBG-1742922019261	eae03b60-99e9-49da-9878-4006c2f2c7df	b33dc683-b9ad-4eb6-8b38-53250b250cc6	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNvdmFiZXg3MzZAaXNvcmF4LmNvbSIsImlhdCI6MTc0MjkyMjAxNiwiZXhwIjoxNzQzNTI2ODE2fQ.48tTHKQxOSXz1xoDUQcIVTTuLE90-yvOc_xGn_Y4aUo	0
0	Kedaluarsa	\N	19bda15a-0794-4ff9-9c5e-eaa321a46aa6	2025-03-28 17:00:18.486804+00	CBG-1743181218415	eae03b60-99e9-49da-9878-4006c2f2c7df	e231be7c-213e-4500-b437-e7ed94f468a7	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im1vZGFkODc1MzJAZXhjZWRlcm0uY29tIiwiaWF0IjoxNzQzMTgxMjE2LCJleHAiOjE3NDM3ODYwMTZ9.FUXC8rKbaPSlbZHp2lPJXECNWmikvj5pZi4Qo1tDO9Y	0
0	Kedaluarsa	\N	858343bf-bf1e-4e2d-9893-f70ef7145dd2	2025-03-28 17:00:18.497114+00	CBG-1743181218423	eae03b60-99e9-49da-9878-4006c2f2c7df	0fed73db-0c6d-4f95-a913-48b1131595fc	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im5lcm9ub3Y0NjBAZXhjZWRlcm0uY29tIiwiaWF0IjoxNzQzMTgxMjE2LCJleHAiOjE3NDM3ODYwMTZ9.13cBPBfF1CJ8QTH7wYPW8kvYqqlDrFW1R4_YDhF8E-0	0
0	Kedaluarsa	\N	5ae65f8a-f7bc-4c3d-a031-56cf16e33f76	2025-03-28 17:00:18.512705+00	CBG-1743181218437	eae03b60-99e9-49da-9878-4006c2f2c7df	530de47b-18ce-4200-865f-fece556044c2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImdlYmF3YW0yNTlAZG1lbmVyLmNvbSIsImlhdCI6MTc0MzE4MTIxNiwiZXhwIjoxNzQzNzg2MDE2fQ.uvdXcwLJpC1YsAcjYjKs6Agi9EvBcbixdaUtSSxybLc	0
0	Kedaluarsa	\N	c148e2eb-4609-4e6f-8c2f-fdd8fe17d9e3	2025-04-01 17:00:19.864911+00	CBG-1743526819773	eae03b60-99e9-49da-9878-4006c2f2c7df	8ea1e721-d977-412f-86fb-17585368a773	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImRld2lkbzEyOTZAZXZsdWVuY2UuY29tIiwiaWF0IjoxNzQzNTI2ODE3LCJleHAiOjE3NDQxMzE2MTd9.OW6ZvOn2RuHxZbZrbOgAU5iY4HIGntYqbgy0hFF7OE4	0
39000	Kedaluarsa	\N	20eb84f7-8a6d-4237-9aa9-cda61e972b41	2025-04-06 02:10:23.128267+00	CBG-1743905423020	8b1abc6b-f501-4d0b-99a0-913886ff9e98	563694c4-3b7f-4a17-accd-f42f40131373	5054c00dddd4a72615b3d646bcc0d64ae5ce24e4530f51be5af71ef859680267	0
0	Kedaluarsa	\N	1a446f5b-739f-405b-8dca-b98b4e78cdf6	2025-04-22 17:00:20.108018+00	CBG-1745341219997	eae03b60-99e9-49da-9878-4006c2f2c7df	e32ad1af-905e-4781-86ae-389edd96ff9d	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNhdm9ob3gzOTZAY2x1YmVtcC5jb20iLCJpYXQiOjE3NDUzNDEyMTcsImV4cCI6MTc0NTk0NjAxN30.CSeMfDWKePdmfOu95ZQJa00NPLeO26R_27sQdRBj3to	0
0	Kedaluarsa	\N	ea9c98ea-a735-4835-980e-4fb10203931d	2025-04-23 17:00:19.623107+00	CBG-1745427619516	eae03b60-99e9-49da-9878-4006c2f2c7df	361333db-632e-44b4-9192-7f4861046172	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNhaWZ1bG11aGFtbWFkNDE0QGdtYWlsLmNvbSIsImlhdCI6MTc0NTQyNzYxNywiZXhwIjoxNzQ2MDMyNDE3fQ.HgVBeS9qwlSiG8RajhrzOIIHQqgOItBlPw5w2ZhYHSo	0
39000	Kedaluarsa	\N	dcc492eb-7914-4f28-b2f2-fa54ce190f1c	2025-04-27 12:39:09.997335+00	CBG-1745757549922	8b1abc6b-f501-4d0b-99a0-913886ff9e98	ae3cc332-1d0e-4af9-bf90-c4047370fc63	1a42ee5aafc5e1edf75e5cb350f99357f5e3fd2ec3f045b98ee26beffefb4497	0
530000	Kedaluarsa	\N	1ba0f746-9023-493a-95f5-41f9d9df68f4	2025-05-04 07:08:57.894795+00	CBG-1746342537826	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	ff9c0083-6186-40e8-b24a-0801bec4e4f4	d956300d2a8749d4ab6d09f3cab6d370df79050fb835435655f70da76ec00b8c	0
0	Kedaluarsa	\N	5cbf879d-dca0-4b63-bd43-880506d12fff	2025-05-08 17:00:22.236065+00	CBG-1746723622160	eae03b60-99e9-49da-9878-4006c2f2c7df	ab309022-bcc9-4e04-8abc-d61c4afd3416	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImthbGVubzE0MDlAY3lsdW5hLmNvbSIsImlhdCI6MTc0NjcyMzYxOSwiZXhwIjoxNzQ3MzI4NDE5fQ.p7E2H6MdLwQ9nNcM_d6na43ukyZA57_PN4UFSvrQ_p0	0
39000	Kedaluarsa	\N	81cec41b-f331-4177-8499-e0fbf9b36239	2025-05-22 17:00:20.217792+00	CBG-1747933220139	8b1abc6b-f501-4d0b-99a0-913886ff9e98	d73cfd09-e4ca-415d-880b-d5944c8a04df	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImdlZGV5aXQ0NTJAYXN0aW1laS5jb20iLCJpYXQiOjE3NDc5MzMyMTcsImV4cCI6MTc0ODUzODAxN30.wpUp69mUQDAsfNgxhP3tiRTrFySv8KanVUK2PsPRR_I	0
45000	Kedaluarsa	\N	ee4a579c-3155-43f6-8f16-68b451c7b9b0	2025-06-14 11:49:25.527498+00	CBG-1749901765453	8b1abc6b-f501-4d0b-99a0-913886ff9e98	3cf34541-51de-42f8-9c16-5b95020d9fff	\N	0
530000	Kedaluarsa	\N	644a4a1e-bd03-43c7-bc47-fe312a05d58e	2025-06-15 03:26:37.573886+00	CBG-1749957997454	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	8bd96235-350d-4f6f-9489-3f80122e1c77	\N	0
125000	Kedaluarsa	2025-07-28	38db16c4-d29c-46ad-8a67-a9efd916cf4a	2025-07-25 17:00:16.783182+00	CBG-1753462816675	8b1abc6b-f501-4d0b-99a0-913886ff9e98	8be70116-5bc2-4a51-a3b5-5001739899ae	\N	0
45000	Kedaluarsa	2025-08-10	b76efae5-cad9-40ed-b6a0-a7cd6f24c003	2025-08-07 17:00:17.649705+00	CBG-1754586017559	8b1abc6b-f501-4d0b-99a0-913886ff9e98	18184643-ccb7-4f42-aa82-d423445bcf3d	\N	0
45000	Kedaluarsa	2025-08-17	150a7172-c298-471d-9fff-1fb53e6413fe	2025-08-14 17:00:17.297333+00	CBG-1755190817231	8b1abc6b-f501-4d0b-99a0-913886ff9e98	e128e7f5-d6b1-4895-98d0-84583540da63	\N	0
125000	Kedaluarsa	2025-09-10	0a748e1c-032d-43a1-b76f-16bb33a168e2	2025-09-07 17:00:18.077497+00	CBG-1757264417941	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	5f892fcb-c56a-4059-ba66-e581e45e3a67	\N	0
530000	Kedaluarsa	2025-09-26	0d05d57f-0f53-419c-b0ea-cb0384cee22e	2025-09-23 00:42:12.268357+00	CBG-1758588132166	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	f048badd-8538-46fe-bd12-ddfaa30646b2	\N	0
45000	Kedaluarsa	2025-11-13	4852e025-5d19-4942-8580-0b7b14018016	2025-11-10 12:08:21.501749+00	CBG-1762776501420	8b1abc6b-f501-4d0b-99a0-913886ff9e98	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	\N	0
45000	Kedaluarsa	2025-07-23	96eb7a1a-c20a-4361-9485-a0d1fad02671	2025-07-20 03:27:10.82983+00	CBG-1752982030721	8b1abc6b-f501-4d0b-99a0-913886ff9e98	7728b222-a096-4da0-96af-0b7934f8b9ba	\N	0
45000	Kedaluarsa	2025-12-08	c913cb55-e38a-40e5-988e-ba63c4bc9c28	2025-12-05 17:00:17.913347+00	CBG-1764954017782	8b1abc6b-f501-4d0b-99a0-913886ff9e98	83731f63-30af-4793-be22-43d9b622e7d4	\N	0
45000	Kedaluarsa	2025-12-29	134a9ce7-80e1-428c-ac5a-e63e5a20dc75	2025-12-26 02:08:36.123027+00	CBG-1766714916090	8b1abc6b-f501-4d0b-99a0-913886ff9e98	3d57f37f-755f-42b5-a3a4-9de23314881a	\N	0
45000	Kedaluarsa	2025-12-29	9e2e5deb-4828-4084-98d4-15df89f4b061	2025-12-26 02:09:09.585115+00	CBG-1766714949553	8b1abc6b-f501-4d0b-99a0-913886ff9e98	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	\N	0
125000	Kedaluarsa	2026-01-01	4b44bdd2-d179-4d5b-a95a-d694f0f268e1	2025-12-29 13:47:33.427431+00	CBG-1767016053363	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	40b66b3d-ca74-414c-8879-3318ab49ce38	\N	0
45000	Kedaluarsa	2026-01-01	d3cd57fb-e6a5-4484-8873-6793ef524728	2025-12-29 13:56:31.001415+00	CBG-1767016590935	8b1abc6b-f501-4d0b-99a0-913886ff9e98	d74b18af-dd09-42f1-97c6-1286fb33604c	\N	0
45000	Kedaluarsa	2026-01-01	8212d0d0-e8bd-45eb-b00f-a1c664cff018	2025-12-29 14:00:59.89863+00	CBG-1767016859833	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9673cd3f-9374-4ecc-a569-d750f3f3ff34	\N	0
45000	Kedaluarsa	2025-12-27	9d1e53d8-f822-44ef-9855-89e13becf9d3	2025-12-24 11:58:58.318458+00	CBG-1766577538216	8b1abc6b-f501-4d0b-99a0-913886ff9e98	acb4da41-865e-40d9-a330-070c0a2b88c8	\N	0
45000	Kedaluarsa	2025-12-27	9183338c-7f00-44e4-b124-57fac1be6711	2025-12-24 12:05:47.312713+00	CBG-1766577947198	8b1abc6b-f501-4d0b-99a0-913886ff9e98	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	\N	0
45000	Kedaluarsa	2025-12-27	78d5febb-cdee-4c6f-a333-6f73d88bc65a	2025-12-24 12:09:41.112828+00	CBG-1766578181002	8b1abc6b-f501-4d0b-99a0-913886ff9e98	dd479ee9-79bd-4642-b46a-d87f97446a78	\N	0
45000	Kedaluarsa	2025-12-27	2ad423b5-9e21-4ce1-b105-ba0655fbd186	2025-12-24 12:15:35.312033+00	CBG-1766578535199	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	\N	0
45000	Kedaluarsa	2026-01-23	0fb668cd-43d4-40d3-9a4d-97b422306dcb	2026-01-20 17:00:19.809653+00	CBG-1768928419679	8b1abc6b-f501-4d0b-99a0-913886ff9e98	20a1b60b-2c45-4533-a02e-ad9d4545b860	\N	0
45000	Kedaluarsa	2026-03-04	64dc7bc1-5eed-43af-8447-f820dfaaff60	2026-03-01 08:18:53.804818+00	CBG-1772353133732	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
45000	Kedaluarsa	2026-03-04	52b20cc0-62d8-4e7a-96c3-cee5a3c6d24f	2026-03-01 08:20:15.093003+00	CBG-1772353215019	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
45000	Diterima	2026-03-04	c34225ac-df80-403f-8129-7302353df3a9	2026-03-01 08:59:50.972939+00	CBG-1772355590927	8b1abc6b-f501-4d0b-99a0-913886ff9e98	3d54010f-5655-4c05-bed1-4984d5347c93	\N	0
45000	Diterima	2026-03-11	5f23c50f-7d34-4d58-94a6-072c00de86cc	2026-03-08 23:20:58.92803+00	CBG-1773012058869	8b1abc6b-f501-4d0b-99a0-913886ff9e98	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	0
\.


--
-- Data for Name: app_plans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_plans (name, id, code, price, duration, created_at) FROM stdin;
Gratis	eae03b60-99e9-49da-9878-4006c2f2c7df	gratis	0	14	2024-11-14 16:15:45.44881+00
Berlangganan 1 Bulan	8b1abc6b-f501-4d0b-99a0-913886ff9e98	1bulan	45000	30	2024-11-14 16:16:26.254346+00
Berlangganan 3 Bulan	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	3bulan	125000	90	2025-05-01 13:46:49.617123+00
Berlangganan 12 Bulan	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	12bulan	530000	360	2025-05-01 13:46:49.617123+00
Berlangganan 6 Bulan	6c43c4ed-1625-441c-af43-feb446b7f7b1	6bulan	260000	180	2025-05-01 13:46:49.617123+00
\.


--
-- Data for Name: app_subscriptions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_subscriptions (start_date, end_date, status, id, created_at, user_id, plan_id, user_plan_price) FROM stdin;
2025-05-01	2025-05-01	\N	1f33858a-8eba-4e69-bce7-a3c4288d1bca	2025-05-01 14:44:43.718907+00	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	8b1abc6b-f501-4d0b-99a0-913886ff9e98	125000
2025-11-10	2025-12-10	\N	28abc5a4-a2a5-418d-803c-d918a8cb7c3f	2025-11-10 14:31:41.288999+00	83731f63-30af-4793-be22-43d9b622e7d4	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-09-09	2026-11-23	\N	7e287cd9-935f-40e5-bdac-f84fb2e4ae6e	2025-09-09 15:02:16.785704+00	7aefc064-bbad-40cc-b31e-645c90c9116c	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-05-01	2025-01-06	\N	5ab41aa3-b539-4f7a-8b0d-5bbf5d28f5cd	2025-05-01 14:48:08.923158+00	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	8b1abc6b-f501-4d0b-99a0-913886ff9e98	125000
2025-05-01	2025-07-30	\N	ea45b196-b997-48d6-9b9d-f09e5cb6d3bb	2025-05-01 15:07:25.012375+00	8be70116-5bc2-4a51-a3b5-5001739899ae	8b1abc6b-f501-4d0b-99a0-913886ff9e98	125000
2025-05-04	2025-05-04	\N	8f3ebb46-61f3-4561-ad48-237a7b6a2bad	2025-05-04 07:08:56.155476+00	ff9c0083-6186-40e8-b24a-0801bec4e4f4	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	530000
2025-05-21	2026-05-16	\N	54602405-ee5c-4557-bd94-66657152db4f	2025-05-21 03:00:57.173771+00	490e65e1-0159-4a63-855c-b3ed8e621ef4	8b1abc6b-f501-4d0b-99a0-913886ff9e98	530000
2025-09-23	2026-01-10	\N	43637941-28af-4760-b1a4-8d32cb608dbf	2025-09-23 12:04:44.520996+00	8db3f967-5f09-4150-a95b-010faa31a22a	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-06-14	2025-06-14	\N	a547bf55-8a75-4e52-80ef-d2e38d60d6dd	2025-06-14 11:16:09.289206+00	704b9e26-e5ce-4f92-9b5d-ded4eecace01	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2024-12-18	2025-03-30	approved	2ed5e6ab-7653-4a4f-b4c6-0cbf3a6d6916	2024-12-25 02:52:46.055109+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2025-06-14	2025-09-12	\N	14185d32-d2f7-4be5-93e1-f7609f6af522	2025-06-14 11:30:20.357652+00	5f892fcb-c56a-4059-ba66-e581e45e3a67	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2025-06-14	2025-06-28	\N	03f58299-692b-4779-896e-a9ba0c8a60c8	2025-06-14 11:46:02.131909+00	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-06-14	2025-06-28	\N	3a3d6773-bfec-44fd-84ba-cdfadbf03ae5	2025-06-14 11:48:28.024495+00	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-06-14	2025-06-14	\N	a1efaee4-d222-446a-a01f-2f9b0f82d3ff	2025-06-14 11:49:25.270914+00	3cf34541-51de-42f8-9c16-5b95020d9fff	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-06-15	2025-06-29	\N	856f6288-59ee-476a-8276-c9272482b3c5	2025-06-15 03:16:52.014793+00	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-06-15	2025-06-29	\N	0a596797-149d-456e-96d8-9487ffc9bf23	2025-06-15 03:18:59.471458+00	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-02-13	2025-02-27	\N	5cf194f0-f33c-47c2-8b4a-1b9fed0faceb	2025-02-13 07:39:13.871287+00	d9c0bf10-e555-4a6f-afa8-ec012d641035	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-01-25	2025-03-21	\N	5390ea49-4c47-46e8-b468-23566fc7956d	2025-01-25 09:09:09.177515+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2025-06-15	2025-06-29	\N	0c12caa2-a971-4521-b198-02ed46fb753d	2025-06-15 03:20:21.045695+00	ddc18a20-f5e5-48d3-a94d-9febac756a86	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-02-23	2025-03-09	\N	3794eb7f-98f0-4708-a114-795a4beaaf8a	2025-02-23 09:26:02.996119+00	cc996432-8af0-4d72-9dd8-022ee19ff6e1	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-06-15	2025-06-15	\N	3b796592-7501-4d0f-8ce7-e554faf5b49e	2025-06-15 03:26:35.822242+00	8bd96235-350d-4f6f-9489-3f80122e1c77	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	530000
2025-03-04	2025-03-18	\N	623b3189-9c24-4e82-9956-55d646e6e96f	2025-03-04 22:29:41.410255+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-03-09	2025-03-23	\N	e8e3fff2-322f-4987-a786-c3115bdc8227	2025-03-09 04:58:22.092259+00	aea1e62f-72db-4b8a-af7e-1d72bd34665b	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-02-23	2025-04-28	\N	8d7059ca-d298-4304-8e73-4e1edb58c6b4	2025-02-23 07:24:51.024463+00	361333db-632e-44b4-9192-7f4861046172	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-03-14	2025-03-28	\N	195e7745-8c3a-4e80-bdc0-fdc75285fe68	2025-03-14 02:18:15.692508+00	6604cebe-ece2-42dd-80de-f4cd5e8fb559	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-03-16	2025-03-30	\N	d146a75a-f584-422c-ac9b-45f25ef887e8	2025-03-16 06:08:49.460845+00	85239af0-2860-4e35-9f6f-5aa79a10ceb7	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-03-16	2025-03-30	\N	94fabd29-aca7-415e-974f-1eedb332f848	2025-03-16 07:23:01.797236+00	b33dc683-b9ad-4eb6-8b38-53250b250cc6	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-03-17	2025-03-17	\N	19e1bd1c-2f2d-419c-816a-181eb8ef5653	2025-03-17 11:04:06.505446+00	68711dbd-970a-4517-b999-1a47df6c550e	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2025-03-17	2025-03-17	\N	6ddf51b3-cc97-4107-90c8-e8450f2850d5	2025-03-17 12:55:07.993204+00	9123b156-5e22-44b6-b7fa-a8c76a51f178	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2025-03-19	2025-03-19	\N	fa922150-5d0a-4d7a-9c72-92ba5deacee1	2025-03-19 06:52:49.758249+00	9e80ef92-c070-4cc5-b5f3-060f347d2c87	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2025-03-19	2025-04-02	\N	a5803191-b7a9-46a8-a9bb-d98bcbc3414e	2025-03-19 07:03:24.699896+00	0fed73db-0c6d-4f95-a913-48b1131595fc	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-03-19	2025-04-02	\N	234e0df5-bbb4-4114-8ad9-95a22323f27e	2025-03-19 14:08:06.608704+00	e231be7c-213e-4500-b437-e7ed94f468a7	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-03-19	2025-04-02	\N	08b129c6-fa40-4d86-9a7c-844b9581bb4b	2025-03-19 22:04:24.336024+00	530de47b-18ce-4200-865f-fece556044c2	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-03-23	2025-04-06	\N	7b527db4-c7cc-4c15-91b1-1e5694511476	2025-03-23 02:52:00.844013+00	8ea1e721-d977-412f-86fb-17585368a773	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-03-23	2025-03-23	\N	45f9f60a-ad5d-4b75-a230-a6a1394fa2e3	2025-03-23 03:13:17.631334+00	7e2288a2-3004-4784-aac2-a3c2fb4155f9	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2024-01-28	2025-03-28	\N	1c3ca723-078d-49f9-ba9e-3c0075922a89	2024-12-25 02:12:46.259719+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2025-03-23	2025-03-23	\N	98cdf725-c2eb-4107-b632-b205372fd5b5	2025-03-23 04:02:27.826682+00	a2eed2f1-b740-4512-8d71-368c2df49c59	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2025-04-06	2025-04-06	\N	22e04af3-e797-4de6-ada2-408867b67d9e	2025-04-06 02:10:21.522659+00	563694c4-3b7f-4a17-accd-f42f40131373	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2025-04-13	2025-04-27	\N	dbe57bb5-0b99-4651-a43f-e5ab54d35cd7	2025-04-13 10:21:02.318835+00	e32ad1af-905e-4781-86ae-389edd96ff9d	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-04-27	2025-04-27	\N	a32d1598-1ba4-4e6e-9709-244a68d825e6	2025-04-27 12:39:08.468133+00	ae3cc332-1d0e-4af9-bf90-c4047370fc63	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2025-06-15	2025-06-15	\N	7d5b21db-cd7f-48c7-be01-2a0669d95c72	2025-06-15 12:21:33.761061+00	eea90897-1470-4ff5-a32d-cabb71375c9e	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-04-29	2025-05-13	\N	fec64cc4-7b7e-4f6a-9ecc-87cf106cfb82	2025-04-29 06:42:30.509546+00	ab309022-bcc9-4e04-8abc-d61c4afd3416	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-05-01	2025-05-01	\N	d4a848e1-1708-4d37-9304-60317001d675	2025-05-01 14:30:59.27149+00	f12d64af-30ce-46bb-821e-8dd6b9eec514	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2025-04-27	2025-05-27	\N	1f8e31a9-648c-4b1b-a4f9-7b1d21ee33dd	2025-04-27 12:44:32.542946+00	d73cfd09-e4ca-415d-880b-d5944c8a04df	8b1abc6b-f501-4d0b-99a0-913886ff9e98	39000
2025-05-01	2025-05-01	\N	b1a407fa-8075-43c9-82d3-8e643016b870	2025-05-01 14:42:42.226511+00	a145d8a1-8899-4a15-90a2-bc20da194e04	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2025-05-01	2025-05-01	\N	0b38aa86-a276-421a-b9b2-c08b25a4fdc4	2025-05-01 14:44:04.491166+00	b1b00121-0f27-43b2-aa80-5d2094bfff62	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2025-06-15	2025-06-29	\N	276eb4e3-96f7-4ab6-b5f1-b12797aa5eed	2025-06-15 12:59:19.808842+00	1ad21901-807d-4aa4-80d4-640876d4faab	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-06-15	2025-06-15	\N	70ec755f-2fcd-4a83-acf0-4fc0870cecc7	2025-06-15 13:01:07.661656+00	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2025-06-16	2025-06-30	\N	4ecae4b4-6509-46fc-a1c8-00357047fbdf	2025-06-16 14:43:24.145919+00	b54508fb-9003-4919-93e3-096d0b87f9a8	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-07-07	2025-07-07	\N	3ff042e6-4689-41df-a9f2-e2141db21ee0	2025-07-07 15:47:06.8339+00	0a78c027-5af9-4360-9ffb-c4b89ada5fdb	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-07-07	2025-07-07	\N	08b3e9f9-d31e-4dfa-ba30-342d8a874faf	2025-07-07 15:52:34.187715+00	2003c690-4cf7-46cb-9362-2f6c2d911db7	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-07-07	2025-07-07	\N	612f3a05-09b4-4f7d-9267-d050f0642428	2025-07-07 15:53:35.080092+00	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-07-07	2025-07-07	\N	623b2465-ac93-42e8-b3ed-bee6ea90d65f	2025-07-07 15:55:46.103879+00	7e214247-26dc-49cc-af5e-48926de89be6	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-07-07	2025-07-07	\N	fb7009ca-c41b-4c14-97bb-39286243692e	2025-07-07 15:57:48.435304+00	1c5e12f4-a59a-4838-83cc-bf399f5b9221	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-07-07	2025-07-07	\N	2e2a7f5c-49be-440a-be5e-cee4737c3244	2025-07-07 16:03:07.985955+00	a7d92f73-5755-49a1-971c-5e14c1d47a31	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-11-10	2025-11-24	\N	91845fb6-1e0a-4664-a8d8-a231fee7bbc2	2025-11-10 12:03:00.747451+00	9e9f89b7-0659-411f-b06d-d75bff0eb648	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-07-12	2025-07-26	\N	0ccd6f75-df8a-434b-99b1-8d05e7237777	2025-07-12 05:40:22.069568+00	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-07-12	2025-07-26	\N	509f86d6-4251-4892-bcbe-a1013900cb83	2025-07-12 05:52:39.431955+00	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-07-12	2025-07-26	\N	aa06e75c-fb2c-456a-9b4f-5e5f5daecf7c	2025-07-12 06:03:31.103948+00	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-07-13	2025-08-12	\N	429820db-707e-4bda-a845-506e5aa43c6c	2025-07-13 07:23:35.711631+00	18184643-ccb7-4f42-aa82-d423445bcf3d	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-11-12	2025-11-26	\N	e9a69971-23bc-42e0-8c2f-1214703927d4	2025-11-12 23:20:09.668774+00	6fed4540-3689-4ee4-837d-614174568f7d	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-07-20	2025-08-19	\N	689ff010-d6bc-429f-bf00-3c85177902d0	2025-07-20 03:20:14.300626+00	e128e7f5-d6b1-4895-98d0-84583540da63	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-11-10	2025-11-10	\N	998f9cd6-5852-4bf9-9b75-f7594dd2b68a	2025-11-10 12:08:19.510241+00	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-07-20	2025-07-20	\N	832926f4-50d3-4be7-9676-6cf76c020599	2025-07-20 03:27:08.871557+00	7728b222-a096-4da0-96af-0b7934f8b9ba	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-08-05	2025-08-19	\N	81b62259-0891-48f8-99c5-8c1dd09c4e76	2025-08-05 14:27:20.662861+00	d9453749-87fb-469d-a93a-22a577b0e98b	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-08-12	2025-08-26	\N	17dd36bb-d2de-40eb-bc4a-a3fb80667414	2025-08-12 13:48:13.097169+00	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-08-26	2025-09-09	\N	f93b467c-7371-4137-902f-5aabe53e8f3b	2025-08-26 13:33:51.760202+00	fe4e3388-40d9-422a-8140-a5a21ab56fbb	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-09-23	2025-09-23	\N	b24db629-bcb1-4fd5-8539-81ee7896142f	2025-09-23 00:42:10.23876+00	f048badd-8538-46fe-bd12-ddfaa30646b2	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	530000
2025-12-24	2025-12-24	\N	63f28b8c-b34a-49d4-b57b-db7a28d9ee37	2025-12-24 11:58:56.314756+00	acb4da41-865e-40d9-a330-070c0a2b88c8	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-12-24	2025-12-24	\N	ec29944a-3b9e-4a36-a071-733181f833fe	2025-12-24 12:09:39.215685+00	dd479ee9-79bd-4642-b46a-d87f97446a78	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-12-24	2025-12-24	\N	6d685261-f1ea-4002-8c46-ed03f40112a4	2025-12-24 12:05:45.186552+00	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-12-24	2025-12-24	\N	4bcc1424-9a30-43dc-a5d9-a49548d70120	2025-12-24 12:15:33.20994+00	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-12-26	2026-01-25	\N	3f72cf50-767e-4ba2-8196-7d675100966d	2025-12-26 02:01:09.026609+00	20a1b60b-2c45-4533-a02e-ad9d4545b860	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-12-26	2025-12-26	\N	24e9c1cc-9f7c-4cba-88db-2e52af75f320	2025-12-26 02:08:35.55311+00	3d57f37f-755f-42b5-a3a4-9de23314881a	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-12-26	2025-12-26	\N	cf897d03-be5e-44ce-9821-4600c2c3caca	2025-12-26 02:09:08.902989+00	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-12-29	2025-12-29	\N	011e9bd5-adac-4288-bb7e-a75fd7cdddb4	2025-12-29 13:47:31.44+00	40b66b3d-ca74-414c-8879-3318ab49ce38	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2025-12-29	2025-12-29	\N	31aa4c6f-d49b-4385-a778-6cd6837b6d02	2025-12-29 13:56:29.097454+00	d74b18af-dd09-42f1-97c6-1286fb33604c	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-12-29	2025-12-29	\N	15ceb13c-3028-4147-89f3-f8ef5536b498	2025-12-29 14:00:57.923802+00	9673cd3f-9374-4ecc-a569-d750f3f3ff34	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2025-12-29	2025-12-29	\N	8d808958-3f4d-487e-a479-f73f30e65e99	2025-12-29 14:02:51.68614+00	ba472db5-f09a-48c3-b6c9-e3233acfc46f	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2026-02-21	2026-03-07	\N	2769b64f-58f8-4698-b8ae-6b79d607bfc0	2026-02-21 07:39:46.975635+00	6e56ab91-182b-4f44-b226-d1f0dc289423	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2026-02-21	2026-03-07	\N	9760eabc-de37-42d8-9d9f-711dccf85562	2026-02-21 07:40:46.028351+00	579c0264-e4bf-4cac-881d-2d3aa5fff59d	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2026-02-21	2026-03-07	\N	a4508a0d-2015-4cea-8a69-cba816a220c6	2026-02-21 07:41:12.624968+00	8d468ffc-f533-48ba-8c6b-285d63647a99	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2026-02-21	2026-03-07	\N	bef9b846-33ee-4ad2-892d-8d66b65a8f28	2026-02-21 07:41:28.263104+00	65e7caf4-1316-49da-a3b9-3b7f8fef3955	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2026-02-22	2026-03-08	\N	bc412946-436c-4b84-b008-2af3bda8d867	2026-02-22 12:46:23.829615+00	cf7cfef7-6850-46c2-9efc-22c28cb0922c	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2026-03-08	2026-04-07	active	a5e93504-e345-4357-984d-568c31634ab2	2026-03-08 23:20:56.955456+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2026-02-27	2026-02-13	active	b100f9b6-1424-4a3e-b07e-89cc1bf57b9a	2026-02-27 22:29:07.594423+00	4b843f69-8041-4846-8af4-872de4c5c41e	eae03b60-99e9-49da-9878-4006c2f2c7df	0
2025-12-29	2025-12-29	inactive	b0994cf8-f44c-4bb8-8d07-54cf36a1586b	2026-03-01 08:56:02.853852+00	3d54010f-5655-4c05-bed1-4984d5347c93	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2026-03-01	2026-03-31	active	c28022b4-6e41-4f4a-a805-cc2597f5642b	2026-03-01 08:59:50.424221+00	3d54010f-5655-4c05-bed1-4984d5347c93	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2026-02-27	2026-02-28	inactive	0d7bfba5-58c2-4abe-9fef-31b1414093e0	2026-02-27 15:44:32.34295+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2026-02-27	2026-02-27	inactive	a85bef5b-f04c-42e6-9397-1d7cfc03894f	2026-02-27 15:47:02.094396+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2026-02-27	2026-02-27	inactive	b964a03e-db3e-4a39-94eb-66804389de43	2026-03-01 08:17:26.811348+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2026-02-28	2026-02-28	inactive	3f7bd995-7fca-4510-acb0-95bff95c3e9a	2026-03-01 08:20:14.581009+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2026-03-01	2026-03-01	inactive	fee05e78-0084-416a-90e9-636b23bf4c87	2026-03-01 23:30:12.998201+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	530000
2026-02-27	2026-02-27	inactive	d39a358e-3e90-45e9-9829-b64c556266a8	2026-02-27 15:18:07.66643+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	530000
2026-02-27	2026-02-27	inactive	ebe87429-e519-4b27-9bb6-d4e2eab630c3	2026-02-27 15:18:29.318865+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	530000
2025-05-25	2026-07-21	inactive	18cdc88c-3343-4d38-9ea5-659224adca26	2025-05-25 13:38:01.759768+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
2026-02-27	2026-05-28	inactive	aa20768e-4f42-4b95-921f-bfdf84f73ed6	2026-02-27 14:30:17.462996+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2026-02-27	2026-05-28	inactive	0496a1d0-b2d7-4b2c-9775-45a7a4e9e771	2026-02-27 14:31:44.631534+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2026-02-27	2026-05-28	inactive	4638c893-478e-4bed-b8fd-4f9274410132	2026-02-27 14:34:22.084344+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2026-02-27	2026-05-28	inactive	82232c03-a653-4b7f-b81a-2e2dd153e6c2	2026-02-27 14:34:32.452175+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2026-02-27	2026-05-28	inactive	19312135-ed63-49ad-93ef-7ba831802656	2026-02-27 14:35:08.547018+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2026-02-27	2026-05-28	inactive	3acd806e-2c55-4a68-898a-51155154fa55	2026-02-27 14:42:11.61679+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2026-02-27	2026-08-26	inactive	6ebceefc-e806-48f4-bd82-a9332ae7d71a	2026-02-27 14:42:23.236268+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2026-02-27	2026-08-26	inactive	84b295df-bd42-4237-ae74-3c029b43a3fe	2026-02-27 14:59:38.172173+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	125000
2026-02-27	2026-02-27	inactive	cb5d5fab-d1c7-4428-9a9c-7e77828afb3f	2026-02-27 15:14:03.556311+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	530000
2026-02-27	2026-02-27	inactive	f217ba37-1d89-4180-96af-bb7facf5ff7a	2026-02-27 15:16:52.815623+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	530000
2026-02-27	2030-02-06	inactive	7723a67c-d045-4e0b-86ab-e57a0f6e4c0e	2026-02-27 15:19:09.87371+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	530000
2026-02-27	2026-03-29	inactive	c258f424-c6fa-4bc8-acbd-9397dad12743	2026-02-27 15:30:36.667402+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	8b1abc6b-f501-4d0b-99a0-913886ff9e98	45000
\.


--
-- Data for Name: app_transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_transactions (id, created_at, user_id, subscription_id, amount, transaction_date, payment_method, status, file, note, invoice_id) FROM stdin;
fede7a6c-a037-4ef3-92da-20d14b621604	2026-02-26 16:33:06.038047+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N		\N	\N
a547adba-3064-46d7-b286-09decb57a186	2026-02-27 02:46:52.219304+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N		\N	\N
55602c74-7b1b-45d0-861b-47a51b498b27	2026-02-27 02:52:20.996266+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772160739963_payment_proof.jpg	\N	\N
07d93c2f-6297-4cc2-9f1a-847d4bc8a303	2026-02-27 14:24:22.222141+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772202262030_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
a2887bc0-31e1-45d1-98e8-518f415dea1d	2026-02-27 14:30:19.296493+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772202619133_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
4b133f10-6bfd-499c-8d12-60a5787c53cd	2026-02-27 14:31:46.983273+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772202706817_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
586612bb-024a-4545-a1f1-34e63ab52614	2026-02-27 14:34:23.776013+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772202863582_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
d37b1fd5-2b35-45d2-8c11-69e5db683b0c	2026-02-27 14:34:33.913505+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772202873721_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
c902d02e-f1f4-4329-9bb1-a4fb7db11b41	2026-02-27 14:35:10.284453+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772202910075_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
0bb8badd-0f31-42bc-80bd-3ac088693f95	2026-02-27 14:42:13.681307+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772203333559_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
d4028ea0-fb22-425f-9dce-162ee76429a7	2026-02-27 14:42:24.972116+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772203344852_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
55fe0894-0240-4e18-95f7-1ce395fec702	2026-02-27 14:59:40.224993+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772204380111_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
fad6990f-d6c8-443c-8d84-78ea8e487e44	2026-02-27 15:14:06.792269+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772205246697_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
a16a6a22-ebfc-4177-ab36-691dbe74a62f	2026-02-27 15:19:45.271208+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772205585035_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
a9d14864-2a21-462c-9b3a-21c52ea1714e	2026-02-27 15:30:39.156572+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N		\N	\N
478992dd-4b95-483d-ab28-06d4dad9d5d3	2026-02-27 15:44:36.306895+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772207076223_payment_proof.jpg	\N	\N
0d695b92-8af8-4fdd-b03e-864248c51ee0	2026-02-27 15:47:04.601143+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N		\N	\N
45ac8057-14bf-4dc1-862c-da1310c6da47	2026-03-01 07:59:57.724577+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772351997618_payment_proof.jpg	\N	\N
9f3bb3a5-fccf-4289-a73d-8c7dd2190f82	2026-03-01 08:10:51.71721+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772352651601_payment_proof.jpg	\N	\N
246f59a9-12a9-4aab-9a0a-3f89aadc0e92	2026-03-01 08:12:35.505592+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772352755055_eric-dekker-0jqI8_MRBKU-unsplash.jpg	Test	\N
54ace337-89ce-4934-8adb-084c46a64530	2026-03-01 08:13:37.921913+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772352817852_2026-01-25_20-20.png	Test	\N
80d14643-a74c-472c-a35c-6d81ed3b9b1e	2026-03-01 08:14:01.356725+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772352841283_2026-01-25_20-20.png	Test	\N
86850d55-e334-4c7e-a4f5-db7ebccae933	2026-03-01 08:17:28.72677+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772353048599_2026-01-25_20-20.png	Test	\N
0d2d2727-ce08-46f3-91f5-777ef2cfb8d6	2026-03-01 08:18:54.509345+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772353134421_2026-01-25_20-20.png	Test	\N
3f88ee78-69d5-4266-82ca-44de332f6ee1	2026-03-01 08:20:15.757912+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772353215686_2026-01-25_20-20.png	Test	\N
6b3d8108-a535-4cbe-8c00-1bdecf01f953	2026-03-01 08:32:16.782691+00	3d54010f-5655-4c05-bed1-4984d5347c93	\N	\N	\N	\N	\N	invoice/1772353936672_payment_proof.jpg	\N	\N
92e51b02-fc76-4d92-b7fb-350d003db107	2026-03-01 08:48:52.846423+00	3d54010f-5655-4c05-bed1-4984d5347c93	\N	\N	\N	\N	\N	invoice/1772354932727_2026-01-25_20-20.png	Test	\N
e1c9c0b2-c17a-4eb8-a1de-27e968f7961a	2026-03-01 08:56:06.388+00	3d54010f-5655-4c05-bed1-4984d5347c93	\N	\N	\N	\N	\N	invoice/1772355366270_2026-01-25_20-20.png	Test	\N
f065f5d7-50ff-435f-bab2-27ef62894540	2026-03-01 08:59:13.83579+00	3d54010f-5655-4c05-bed1-4984d5347c93	\N	\N	\N	\N	\N	invoice/1772355553727_2026-01-25_20-20.png	Test	\N
1b7ab19d-fc8b-41a6-b694-430b7e7dd356	2026-03-01 08:59:19.107046+00	3d54010f-5655-4c05-bed1-4984d5347c93	\N	\N	\N	\N	\N	invoice/1772355558934_2026-01-25_20-20.png	Test	\N
3e91bf7f-a096-4975-8a70-3811cdda844d	2026-03-01 08:59:51.47346+00	3d54010f-5655-4c05-bed1-4984d5347c93	\N	\N	\N	\N	\N	invoice/1772355591427_2026-01-25_20-20.png	Test	\N
3a085abe-4321-477e-b93a-f4458ea60b15	2026-03-01 23:30:17.071044+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1772407817001_payment_proof.jpg	\N	\N
3c9555e7-f78a-42c3-90d2-26410215b3bc	2026-03-08 23:21:00.927321+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	\N	\N	\N	invoice/1773012060866_payment_proof.jpg	\N	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customer (created_at, merchant_id, id, name, address, phone_number, email, gender) FROM stdin;
2024-11-11 13:38:31.800256+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	d087bd5e-1fcd-40a1-a020-518b53065f73	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:38:34.151179+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	8bbf77d2-3948-4d96-ae9e-2dec7c045130	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:38:34.448461+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	e820041e-755a-435d-b56d-b1b4e6d71e22	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:38:52.329292+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	4908ae10-b51d-4e99-a99e-5ca389fd3d68	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:38:54.083015+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	a0ae43bb-673a-482b-b2a9-35e5b79f905b	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:38:54.983879+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	09a5ad44-ef6f-4cab-a5f9-ff5ebd9eaf3d	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:39:12.019069+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	5e8a5b38-442b-4016-9d71-608105e0576c	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:39:13.496563+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	29f73f38-f84c-4d1f-b670-224b16af3dc3	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:39:13.617547+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	61a79376-56ca-4193-93cc-f522cec6ccf1	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:39:31.842002+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	74a5a0fa-5a91-4a84-becd-de3e6c5408f6	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:39:32.949169+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	18b0ae76-3e28-41c6-be8a-2469f1177c84	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:39:33.199019+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	01792fc4-465a-4742-bdee-aa8dd8becd21	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:39:52.53135+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	a121cb42-7638-44a9-a25a-5266b213ee63	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:39:53.35336+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	f1e78e82-8765-42b8-8730-307a26bc711a	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:01.083098+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	7ef7361c-c8a5-4441-ac76-c2408c8bded1	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:11.233863+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	c0ddf2d5-eaf5-46b6-942a-65c5bc3b1c8f	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:13.825944+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	b1aadbcd-9ee4-45f4-85fb-8ea07e86516a	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:24.905215+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	ae0a706d-44d1-4529-9477-c78dd66f7337	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:31.376423+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	07c51c04-3a1d-43b0-b1d5-9f4c8d68705b	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:39.449466+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	53c91ed0-406b-4ba9-ae6a-58beca810643	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:41.944033+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	a24effe8-4aa3-469c-93b1-4d1f699be9d8	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:45.609456+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	6e0295c0-8ea0-4a90-83fb-00e45953ecca	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:46.594769+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	fd54e487-d5b9-4cb0-998f-017652ef78e0	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:51.115243+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	86d4dcef-0616-4a9f-8360-6f9883c5d777	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:51.503315+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	fd2a819a-7ba2-4644-982f-da4a3e87bbc3	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:40:53.522498+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	da907928-9279-4d32-ba76-0067d151ff82	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:41:02.269385+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	67f68f47-4b82-43ca-8f46-0ca86de8fc02	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:41:04.556983+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	17e33b14-5670-49a3-89ed-9eca55e2b583	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:41:10.634886+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	29204050-387a-4c00-a2c3-201af7a7c763	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:41:10.657772+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	c0893634-a834-4811-8682-a0c21870d081	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:41:12.89164+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	9e5003c0-6b70-4eea-b164-5781e5bafaae	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:41:30.869055+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	ca6ef8f8-3d6f-4f35-9e5e-8432284fd81b	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:41:54.569572+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	313c39eb-2c6c-44eb-991e-bde1b41abed7	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:41:59.480735+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	59679584-003b-472a-8eac-2ca3dfb7ecb6	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:41:59.940707+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	647d7fa8-45a8-4b8e-b756-a7d7a7b6bc61	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:42:14.366225+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	b0ab5148-fedf-4467-9b62-d491eee64033	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:42:15.633128+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	003e9c85-b42d-496f-a2d0-d4774ad17349	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:42:18.538367+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2254096a-dc08-4178-9f81-dad3e7462f74	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:42:19.790671+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	15db41b0-fd7c-4ade-a108-3bedba370ca9	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:42:25.57465+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	98cdd7fc-7278-4820-9c1d-c488666ce3e4	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:42:38.475477+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	751774d5-6608-4000-bd8e-b6d3e9328963	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:42:40.048281+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	289b8087-c01e-4e9c-bc42-82d371e0ff1e	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:42:45.155859+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	8379dc4f-c83d-444b-b8ca-4e554cf54695	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:42:59.384563+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	e74a3228-7c3a-4e89-a658-088b8146e784	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:43:03.305179+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	f54cf1bc-a2f3-46fc-90c6-fcee02ba4696	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:43:12.783753+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	eea0e0cb-7856-4c5e-bcbf-dbf031d39932	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:43:17.686563+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	4f218226-66e4-44c1-88ed-10dc41e6ee0c	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:43:19.759771+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	9c0905b0-f140-4e1a-9b69-6b6c238fb605	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:43:27.893964+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	8820b5b4-c17a-4f71-bff5-d581aa5c370e	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-11 13:43:29.436206+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	09921eae-32a6-4443-b939-6f474000a63f	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-11-16 02:32:54.249305+00	8765c92d-2303-4374-8c45-6f5ee45d6b48	3f9cfdc5-519b-4749-8431-998c215c5096	test123		0987612312	\N	Laki-laki
2024-11-23 14:50:35.112211+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	d38e111f-f94d-4855-8361-4ddfe1ed6fd8	Test Customer 1	Blambangan	+0335946479	testCustomer1@yopmail.com	Perempuan
2024-12-07 14:31:58.584503+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	b81717f0-6b36-4d16-b5c3-82b0f644a705	kssdjf		0832932392	\N	Laki-laki
2024-12-07 14:34:22.430699+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	01715223-f69f-4802-8c16-af15a6dcce6a	iewkewj		08232938310	\N	Laki-laki
2024-12-07 14:32:08.11925+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	05dfc64d-d15e-4e63-ad51-f9cdc2a2cd26	saskas122		0823238723	\N	Laki-laki
2024-12-04 13:32:07.09286+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	220ee915-4c4c-49bc-9510-43b31ab00696	hh22233		0823238732	\N	Laki-laki
2024-12-07 14:34:38.418039+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	ab5108df-d9a2-48cb-91e7-53daf76a7cec	osaskashw		0832329381	\N	Laki-laki
2024-12-07 14:34:56.24768+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	6dba3b08-5909-4534-92ec-65155570b570	doldjaslask		08329328332	\N	Laki-laki
2024-12-07 14:36:00.040317+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	1dc89a35-933a-4622-be6e-462964b094a4	owepwelsd		08372328712	\N	Laki-laki
2024-12-07 14:36:47.919816+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	cce73bfc-181a-48c2-bc4c-2d42b910279a	ytksdjskdj		0823723623	\N	Laki-laki
2024-12-07 15:02:51.221087+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	3fcbe408-a987-4329-95d8-00ac5da15b4a	Hajaha		0826377373	\N	Laki-laki
2024-12-15 09:25:36.56205+00	8ae5aae4-201d-4be3-838d-70c5de9e1a0c	42d0eef3-6bb2-4422-843d-be9e3c14c5f7	ikmal		09831212121	\N	Laki-laki
2024-12-20 08:59:02.156028+00	8ae5aae4-201d-4be3-838d-70c5de9e1a0c	aac618de-2bcf-410e-869a-a3a2e4e5e6d1	sdsd	345	43535345345345	\N	Laki-laki
2024-12-07 14:32:28.925709+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	b6da69ff-f1d2-44c5-a719-1b583677ca87	ksalsk22		08239238293	\N	Laki-laki
2024-12-25 02:59:45.028806+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	516109d7-5bac-4d78-973a-2291d8b8f93c	test	ok	12321321313	\N	Laki-laki
2025-01-13 14:56:52.182972+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	9644af52-6349-44a9-90bf-cb72037d6ade	Yuy	Uu	082738838773	\N	Laki-laki
2025-01-19 02:57:56.244825+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	5c4299c4-17cb-4821-b3cf-3e5fc1ce7b7c	Uj	Yuuuuu	086778787866	\N	Laki-laki
2025-01-19 02:58:25.064712+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	ac764ef4-5537-4101-9dc1-f6b159fb2ba3	Hj	Yuuuhhg	0867788667	\N	Laki-laki
2025-01-19 02:58:45.331538+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	ed6646da-f617-4f6b-a44f-107f6ac6f999	Ipul	Ok	08399269372	\N	Laki-laki
2025-01-19 02:59:00.166+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	90b6f829-c9ef-4903-88e8-5e2c262c9bd9	Opi	Ok	08399269372	\N	Perempuan
2025-01-23 13:08:43.298625+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	efba3273-180b-4b50-adc6-a0176e71e94f	k		08232932833	\N	Laki-laki
2025-01-23 13:09:22.56556+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	095f04b6-a627-4e85-9837-a985f6687d9b	jki		082323981212	\N	Laki-laki
2025-01-23 13:10:42.775599+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	7cffe6c5-0302-40ed-937f-4e158edac142	lo		083293283983	\N	Laki-laki
2025-01-23 13:11:47.913173+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	7a2d5f72-058a-4d8b-b7d7-6a0666a8c0f6	ii		083239382389	\N	Laki-laki
2025-01-23 13:12:51.428077+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	738efca3-213c-4e2e-89eb-7dc6ababad82	ooooo		082323293283	\N	Laki-laki
2025-01-23 13:13:15.129413+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	a444a714-7c52-4d74-a2bb-13897f51203e	kkij		089283239283823	\N	Laki-laki
2025-01-23 13:13:57.383302+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	a1c2948f-8aef-4702-9fbe-8b44ae57f523	kasjasj		0823293283323	\N	Laki-laki
2025-01-23 13:15:18.565567+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	fc4d47cc-e15c-4821-8645-97a4497bf257	ooolll		08923283923823	\N	Laki-laki
2025-01-23 13:17:23.567718+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	e2b6c4ba-03e7-44b8-875c-ea279562725f	plo		0832932382832	\N	Laki-laki
2025-01-23 13:28:59.573339+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	b3ccd893-7654-4d45-85b2-87db24bebbf9	oki		0823238923823	\N	Laki-laki
2025-01-23 13:32:05.735335+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	6bf93240-e352-4c73-be74-3992ba1e6598	okkkk		082323923823	\N	Laki-laki
2025-01-24 00:29:53.30011+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	08d45a38-ed05-474a-8ec4-75f380e9968d	te		082128129182	\N	Laki-laki
2025-01-25 09:10:33.273254+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	4006d2b9-83ae-4676-8cbe-128ded1e5414	Ari	Kosong	08399269372	\N	Laki-laki
2025-01-25 14:36:47.634628+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	a2df0ef0-faea-405f-b5b8-9f6e128e9327	Ipul3		085664221560	\N	Laki-laki
2025-01-25 14:36:56.863185+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	e518fd1e-190d-4143-8106-69c20afcb7a0	Ipul4		085664221560	\N	Laki-laki
2025-01-25 14:37:06.58472+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	12b2af62-f16e-46bf-85e7-ab71e342c917	Ipul5		085664221560	\N	Perempuan
2025-01-25 14:37:28.824901+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	d0749d8b-7d71-4cbe-b04e-c229c39af62f	Ipul8		085664221560	\N	Laki-laki
2025-01-25 14:37:46.947712+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	184c7fc2-9694-425d-a26e-2913dd31f41f	Ipul3		085664221560	\N	Perempuan
2025-01-25 14:38:03.585767+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	f32cc3f0-9367-4c5d-8ae8-a33018778be8	Ipul11		08399269372	\N	Laki-laki
2025-04-13 23:51:53.458453+00	e32ad1af-905e-4781-86ae-389edd96ff9d	1cfc2093-d6bb-4c0a-a20a-97a98e27e234	haha		082728288888888	\N	Laki-laki
2025-01-24 00:39:28.286759+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	532d220e-b4d0-47cd-9808-c515cbe13989	okk67		08232938121	\N	Laki-laki
2025-01-29 12:18:31.780711+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	a2d506a8-dd17-4c84-9e16-0e92a6cbc5e9	Jjkiikhj		0856746785678	\N	Laki-laki
2025-01-23 13:26:37.015432+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	53966fda-c774-421e-a72e-94efcffe17b4	lok		082329328382	\N	Laki-laki
2025-04-20 03:34:49.331623+00	851d6597-49ca-4ec0-8ca9-2a714c68554f	4e53b04d-e73d-44c2-afbc-fc4c1c0b88da	Tes tes		085664221560	\N	Laki-laki
2025-05-21 03:13:26.01852+00	490e65e1-0159-4a63-855c-b3ed8e621ef4	ef9f7380-ba34-429b-ba86-a19027cc5f06	Aya		082977728162	\N	Perempuan
2025-01-24 00:31:05.20992+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	76ba6eab-3d07-4a10-ac98-4e2d0de3b913	kl		082329323832	\N	Perempuan
2025-01-29 00:50:44.894228+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	648bde2b-cd68-4815-84b3-f0d343b9dc0b	Gyiuyy7		08564776667655	\N	Laki-laki
2025-02-01 16:23:08.809573+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	7e00fefe-a509-465a-9034-3f4d63bdea2d	Test okey		0984627262638	\N	Laki-laki
2025-02-15 12:04:11.644104+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	2f9ba031-6bd5-4501-897b-34560766fbaa	rama		082210357112	\N	Laki-laki
2025-03-07 12:44:39.121009+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	94db8b64-e8af-41cd-a89b-2b394c96872a	Haha		086757776655	\N	Laki-laki
2025-03-07 12:51:09.138737+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	98907aa6-c00c-468f-b5dc-0c59495160a0	sdldks		0832938232	\N	Laki-laki
2025-03-07 12:51:27.447666+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	15edb959-4357-4fb3-836a-d7e4f755ffd5	a;sals;		0239239932	\N	Laki-laki
2025-03-07 12:51:46.918738+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	17f67e2d-665d-435a-99c2-65d9b5842bd8	dalsdsk		0834928323	\N	Laki-laki
2025-03-07 12:52:02.031849+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	6a835a56-9b24-4da1-9628-c23657897577	dsldsdk		08232938223	\N	Laki-laki
2025-03-07 12:52:14.742772+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	ffe034f4-375c-47fb-8c1d-3e50966eba4a	kjdsdk		08239238232	\N	Laki-laki
2025-03-07 12:52:27.656334+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	9880a76e-489b-4cb7-bb7f-190ce230e064	iiuuask		0823923823	\N	Laki-laki
2025-03-07 12:53:07.159163+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	3bec8cd8-bad4-49f9-afeb-a0bf3627c0ac	kids8		082210357112	\N	Laki-laki
2025-03-09 11:37:19.537216+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	3da08a86-2fc2-4780-8bd2-c9bdff9beccc	Uhui		0856656777	\N	Perempuan
2025-03-09 14:34:11.044971+00	361333db-632e-44b4-9192-7f4861046172	e8fef3c9-24a5-4185-945d-a1bf441a7494	SIMON		085664221560	\N	Laki-laki
2025-03-16 06:33:03.800969+00	85239af0-2860-4e35-9f6f-5aa79a10ceb7	3fb7f801-4419-498d-bec2-85545146fd68	Ibum		085664221560	\N	Laki-laki
2025-03-16 07:24:38.764131+00	b33dc683-b9ad-4eb6-8b38-53250b250cc6	ab77e0b3-75e9-4349-b0f8-616984764dd2	yyy		08232938238	\N	Laki-laki
2025-03-19 23:36:19.461143+00	e231be7c-213e-4500-b437-e7ed94f468a7	35aa6610-3ee8-481a-8cd9-85cca99b9eb3	Dang		08738286282	\N	Laki-laki
2025-03-30 07:26:15.710089+00	8ea1e721-d977-412f-86fb-17585368a773	9327a2b2-5beb-4680-b199-5905ef43aa48	kksdjsd	kkksd	087232832737	\N	Laki-laki
2025-05-31 03:02:54.772121+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	2ce6aedf-1f23-4444-a1a2-e18e6911a22f	Gaga		08262882727	\N	Laki-laki
2025-08-18 07:16:47.410202+00	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	234b1eee-c7a3-4f13-b660-0b793c1e8add	dksdj		08222323827	\N	Laki-laki
2025-09-01 11:01:49.811826+00	fe4e3388-40d9-422a-8140-a5a21ab56fbb	d8eb0162-cc41-4ea5-bcb6-fcb684ac4b79	hehe		0834734823	\N	Laki-laki
2025-09-12 13:25:20.358471+00	7aefc064-bbad-40cc-b31e-645c90c9116c	90358ac4-3666-497d-9850-ffedcf2cc53f	daksjajd		08327328328	\N	Laki-laki
2025-09-25 14:17:21.52376+00	8db3f967-5f09-4150-a95b-010faa31a22a	b0f3c299-02f9-440a-ac51-a1615bc35695	diyaca8650		085767888888	\N	Laki-laki
2025-09-27 13:44:16.446854+00	8db3f967-5f09-4150-a95b-010faa31a22a	4fcc1210-b3c5-4f59-b293-e652e71d3ff5	jjhjhkii		08246565776	\N	Laki-laki
2025-09-27 13:44:42.427685+00	8db3f967-5f09-4150-a95b-010faa31a22a	336a2d59-a4c8-41ba-bbb7-72dade470525	kjhjgjh		08276767666	\N	Laki-laki
2025-09-27 13:44:59.39475+00	8db3f967-5f09-4150-a95b-010faa31a22a	a71adc7f-f1ff-4ef3-a2f5-d186d082adc3	ghshshshj		8542266884	\N	Laki-laki
2025-10-22 09:55:01.813137+00	8db3f967-5f09-4150-a95b-010faa31a22a	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	rama		082210357112	\N	Laki-laki
2025-10-05 13:41:02.267263+00	8db3f967-5f09-4150-a95b-010faa31a22a	b65e3685-90b2-4835-a18c-46619ec5f279	Helen	Jalan	85664221560	\N	Perempuan
2025-10-05 13:42:03.340531+00	8db3f967-5f09-4150-a95b-010faa31a22a	d8230d29-a0d5-4030-b25a-0b558cad0e9c	Jaka		8546488948	\N	Laki-laki
2025-10-05 13:26:34.738054+00	8db3f967-5f09-4150-a95b-010faa31a22a	7fd4bb2d-8ece-4197-ba9b-63144011b10d	Putri		08329283384	\N	Perempuan
2025-12-10 12:37:07.415409+00	8db3f967-5f09-4150-a95b-010faa31a22a	6eaf519b-e326-48b2-bb5e-3fc7a9915252	Baru	Gggg	0853663555	\N	Laki-laki
2025-12-11 14:08:41.630558+00	8db3f967-5f09-4150-a95b-010faa31a22a	c8da27c4-d68f-491b-9325-ad877db6b7e8	Uuuhuyy		082556652258	\N	Laki-laki
2025-12-26 15:06:46.863253+00	20a1b60b-2c45-4533-a02e-ad9d4545b860	71f1f332-2dd6-43d3-b6db-31d34b812f9c	Nayla 	Jl. Melati RT 25 Rumah Nomer 3	082331649854	\N	Perempuan
2026-02-21 07:42:11.266653+00	65e7caf4-1316-49da-a3b9-3b7f8fef3955	a048aed1-c445-4620-bf19-4c5c9233ea08	Joni		085664221560	\N	Laki-laki
2026-02-21 15:09:40.914569+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	bc242324-3101-40e3-9f6d-93f58aac0b80	Ipul		085664221560	\N	Laki-laki
2026-02-22 13:41:38.281476+00	cf7cfef7-6850-46c2-9efc-22c28cb0922c	edd883bd-66a1-4721-9576-7fe5cdd5d1f9	Dd		082566555666	\N	Laki-laki
2026-02-27 23:50:16.317016+00	4b843f69-8041-4846-8af4-872de4c5c41e	84521ce9-8f91-43e3-aebc-1b5bf002d2f1	Pelanggan1		08288888888	\N	Laki-laki
2026-03-01 09:04:51.591201+00	3d54010f-5655-4c05-bed1-4984d5347c93	4767a7bd-de85-4e68-94e5-97c44ccb4a75	jon	sdfasdf	085664221560	ipulm@gmail.com	Perempuan
2026-03-01 09:10:46.858087+00	3d54010f-5655-4c05-bed1-4984d5347c93	8184d504-d944-47a5-a6f2-9f7057af86ce	Ok		085664221560	\N	Laki-laki
2026-03-01 09:19:42.066326+00	3d54010f-5655-4c05-bed1-4984d5347c93	5deb12b2-f751-4364-be30-8fc42e5618fe	Pel 1		088484888484	\N	Laki-laki
2026-02-24 23:23:18.412444+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	b56003d8-63bf-4f32-b4c2-58c810313a68	jon2	sdfasdf	085664221560	\N	Perempuan
\.


--
-- Data for Name: discounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.discounts (id, merchant_id, name, type, description, is_active, created_at, updated_at, value) FROM stdin;
8a0aeb65-5f82-48c3-be7e-4f684e4fdd89	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Diskon Member 2	percentage	\N	t	2026-03-10 15:51:33.026758+00	2026-03-10 15:51:33.026758+00	12
0b627f22-f7f9-4c2c-80db-672ae67a9e1f	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Diskon Member 2	amount	Potongan untuk member	t	2026-03-10 15:49:10.805399+00	2026-03-10 23:02:16.490688+00	12500
d50d30c9-a58f-4c8f-b070-99c1347889c7	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Diskon Member 2	amount	\N	f	2026-03-10 15:49:36.893122+00	2026-03-10 23:03:29.106584+00	12500
\.


--
-- Data for Name: duration; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.duration (id, duration, merchant_id, created_at, name, type) FROM stdin;
6fbdec27-e93a-48d3-8b34-a51f93848087	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:38:35.022499+00	Kilat	Hari
50b887a2-b122-407c-986f-ac43e12f9105	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:38:37.4247+00	Kilat	Hari
7fa81ef0-cfaa-43ce-bd7f-813e33a8f294	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:38:37.674881+00	Kilat	Hari
7d56b35a-5016-463d-a442-af0cd171f1f0	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:38:55.171726+00	Kilat	Hari
b759fb6d-c1c1-41e3-b8aa-d057f207cb7f	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:38:56.941786+00	Kilat	Hari
1d4ab476-3446-457c-b41e-875e3c57bf0e	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:38:57.895658+00	Kilat	Hari
79be5af6-c3bd-4168-a3ec-0fa57bbfbaa7	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:39:15.186629+00	Kilat	Hari
e661936b-486d-43c4-b429-a1a512ff426c	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:39:16.257877+00	Kilat	Hari
2b38a760-f17e-4e15-891d-c749f02ea1da	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:39:16.491113+00	Kilat	Hari
56bc9702-04ea-45c6-86f9-338641c61437	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:39:34.594903+00	Kilat	Hari
f1f214d8-9348-43e7-bf92-5b757de737ae	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:39:35.643295+00	Kilat	Hari
ace1d6ad-41dc-407d-a64f-9f47aa2d3d63	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:39:35.954217+00	Kilat	Hari
e35d2bd8-3543-43d5-9076-de8be2167caa	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:39:55.358991+00	Kilat	Hari
96fe18c9-7164-4400-be42-fabf51600463	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:39:56.208665+00	Kilat	Hari
ae1901dd-c1a3-4cd3-930c-ac91802ed1b5	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:03.986919+00	Kilat	Hari
7acd16cc-4868-4bfd-8439-8ebdcf372235	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:14.120753+00	Kilat	Hari
cf08a19f-376a-44ed-a97d-afdb72b8afd4	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:16.649889+00	Kilat	Hari
68f7aa6b-bf15-48a5-b22f-6043e4ae9783	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:34.16849+00	Kilat	Hari
6ad527df-c988-46ce-8135-252557f55a55	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:35.624707+00	Kilat	Hari
f2a74d0d-b799-4796-b5c0-ff29ecc2cd93	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:42.400256+00	Kilat	Hari
56eb4144-3f27-4a11-8d3d-45baefe1cd06	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:44.810423+00	Kilat	Hari
940c01d7-444c-45c8-823f-989cafbfe604	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:48.665132+00	Kilat	Hari
e63e7d12-edc2-4c26-8b39-ad36b4e7342d	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:49.399502+00	Kilat	Hari
864d3b92-d11a-4331-9b11-68e15b859ef1	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:54.14098+00	Kilat	Hari
144256d0-7bbe-4e43-8e41-497d07f8a121	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:54.698973+00	Kilat	Hari
4a681c3a-5aa5-4f85-a558-cf4d7741d063	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:40:56.49582+00	Kilat	Hari
6aa13c7c-2fd4-4d2e-bcf3-fa4191807be7	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:41:05.233353+00	Kilat	Hari
417c9249-6dda-49f7-84b3-d1eb32e5704f	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:41:07.378774+00	Kilat	Hari
4e307f31-3b72-4836-b430-7aea3e3685cf	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:41:13.529714+00	Kilat	Hari
a4eb2966-3bb7-404f-b848-ac7ca9663fe2	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:41:13.596488+00	Kilat	Hari
d4953ec6-4901-4aca-80c5-32def27f6fce	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:41:15.788873+00	Kilat	Hari
4a0cae88-e696-4ada-ba36-003ebcebd398	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:41:57.397157+00	Kilat	Hari
f3cf9362-e8d8-4530-8192-e5d094135f47	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:02.226052+00	Kilat	Hari
f0738464-dc8a-4881-aedd-65883b1f6b35	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:02.779375+00	Kilat	Hari
bd75c23a-da27-49fd-a11d-6ad8cf137cf3	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:17.151077+00	Kilat	Hari
72d045e8-b419-4749-b8fc-e736240f7127	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:18.671544+00	Kilat	Hari
fdce2afb-cc10-4a40-8ea9-46287de8d32f	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:21.573008+00	Kilat	Hari
f080f9b6-0e15-4164-922f-918cb3750082	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:22.88756+00	Kilat	Hari
e8b103a0-7eb2-466f-933f-e497a6d8d857	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:28.646999+00	Kilat	Hari
5d537e13-a0d5-4663-9259-9d475eda67fe	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:33.157302+00	Kilat	Hari
547bcdcd-a442-4481-bbfe-ac81b3825a61	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:41.491724+00	Kilat	Hari
4203b1e8-3c6f-4686-836d-c44cdab964f8	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:42.950537+00	Kilat	Hari
57103ce8-5a8f-4537-8dab-08b773af1299	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:42:48.020765+00	Kilat	Hari
55dce91f-2059-4f7b-b90c-99726e498f39	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:43:02.168515+00	Kilat	Hari
9d67d120-7872-4fe4-b7c9-86f2e13f7c37	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:43:06.123771+00	Kilat	Hari
cc2a063d-b18f-4674-aef8-441e5c6ed5c7	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:43:15.625273+00	Kilat	Hari
9b2617d7-ce3b-49e9-b1bd-f2d85e907d79	3	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	2024-11-11 13:43:20.713227+00	Kilat	Hari
d01573c0-7953-49b3-9836-1c6083381d09	1	8765c92d-2303-4374-8c45-6f5ee45d6b48	2024-11-16 02:33:36.113105+00	1 Hari	Hari
8bb5bb41-a20e-4da4-90f1-e265475cfb21	3	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-11-23 14:51:10.876793+00	Kilat	Hari
4fded339-340e-4bf3-886f-8e55bfc74c7b	12	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-11-30 15:41:46.203241+00	FAST	Jam
da8cc09f-4568-4ed8-839b-2195b4e5040e	1	e9bec3fe-766c-41fe-a144-fcb73d705e95	2024-12-04 13:32:32.581381+00	satu	Jam
7d4b163c-923b-4a06-8387-47bd7d5c21b1	23	e9bec3fe-766c-41fe-a144-fcb73d705e95	2024-12-09 14:27:18.679902+00	lksas	Hari
36c073b0-8c80-4f4a-b7dc-f693a2ad6563	8	e9bec3fe-766c-41fe-a144-fcb73d705e95	2024-12-09 14:27:29.590872+00	ldak	Jam
777e58b5-6d7a-427e-a943-110484e3a4e1	2	e9bec3fe-766c-41fe-a144-fcb73d705e95	2024-12-09 14:27:52.226388+00	dskd	Jam
0a60c69c-79fe-4a08-b68e-f80c5b8e8a37	7	e9bec3fe-766c-41fe-a144-fcb73d705e95	2024-12-09 14:28:57.444102+00	yeuj	Jam
69ccec93-7da2-4c29-9966-d87166764089	8	e9bec3fe-766c-41fe-a144-fcb73d705e95	2024-12-09 14:29:07.62225+00	kai	Hari
34e37144-d89e-4bea-92e7-4670f4b1ca46	8	e9bec3fe-766c-41fe-a144-fcb73d705e95	2024-12-09 14:29:32.186918+00	oooo	Hari
13c3a4ca-0b11-43b0-b12c-37680f2cef4c	12	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-12-12 15:33:54.628788+00	<string>	Hari
3ad00fca-30d8-4cf1-ba9c-4ca76b495733	12	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-12-12 15:33:56.479718+00	<string>	Hari
180e0cd7-29f6-4f38-86de-1e4f2dee639b	12	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-12-12 15:34:39.408019+00	dua	Hari
51487fd4-fc20-476a-8742-ceb1af6ccfec	12	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-12-12 15:34:58.385743+00	3	Hari
c7f012d5-7941-4020-b976-42e04d182001	12	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-12-12 15:35:02.064455+00	4	Hari
764f9563-adf7-4743-b2ad-de655e163d24	12	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-12-12 15:35:06.074514+00	5	Hari
3303a779-44b1-4844-90ad-a109e92fe1f5	12	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-12-12 15:35:09.745765+00	6	Hari
365e01f2-1da7-4fdd-b48a-db479c9a74c0	12	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-12-12 15:35:13.867428+00	7	Hari
9d7f60ab-b124-4cbf-a642-6bf5a72e4ca7	12	99eea1df-1d39-4fae-a8ca-65e71349b34c	2024-12-12 15:35:18.279469+00	8	Hari
0c9ecec6-db7b-4d8e-9aa1-01a28ef5ea51	1	8ae5aae4-201d-4be3-838d-70c5de9e1a0c	2024-12-15 09:24:35.041123+00	cepet dadi	Jam
2a6c5a23-4e8e-460b-9ab8-1b1fd6f71a5a	6	99eea1df-1d39-4fae-a8ca-65e71349b34c	2025-01-19 01:19:17.933275+00	kjkkjkjk	Hari
7d5add6a-3a99-4a10-a8e0-8d10bcbe7b25	6	99eea1df-1d39-4fae-a8ca-65e71349b34c	2025-01-19 01:19:27.135817+00	kjkkjkjk	Hari
595fc7eb-b69f-4abb-838d-de28c1c392d3	111	99eea1df-1d39-4fae-a8ca-65e71349b34c	2025-01-19 02:53:44.882223+00	123123	Jam
5add6b4d-1e9c-4a46-920f-093789f4b340	111	99eea1df-1d39-4fae-a8ca-65e71349b34c	2025-01-19 02:55:02.591752+00	123123	Jam
87d2b416-20bc-4af4-9e82-c982469e2649	25	e9bec3fe-766c-41fe-a144-fcb73d705e95	2025-01-19 02:56:49.408274+00	Ji	Jam
902097c2-2f42-419f-9069-044d3db8689a	8	cc3d67d9-aafd-41b4-93e6-c00b588ec078	2025-01-25 14:44:03.185649+00	Kilat	Jam
377ef95d-9062-413f-9e9f-076982599f8d	12	cc3d67d9-aafd-41b4-93e6-c00b588ec078	2025-01-25 14:44:17.272276+00	Pelan	Hari
b25bb62c-7e5f-49c7-a8f6-60b1d192e6e9	1	cc3d67d9-aafd-41b4-93e6-c00b588ec078	2025-01-25 14:44:45.414556+00	Kilat super	Jam
f3b1112b-c474-42fc-b26b-8f8723e79c74	1	cc3d67d9-aafd-41b4-93e6-c00b588ec078	2025-01-25 14:45:02.38341+00	Wuzz	Jam
b5ec2d06-71e1-44b3-94ea-44c21e3386d4	360	cc3d67d9-aafd-41b4-93e6-c00b588ec078	2025-01-25 14:45:16.336306+00	Gratis	Hari
39b9ea9f-323c-425a-90bd-fc800005104c	3	cc3d67d9-aafd-41b4-93e6-c00b588ec078	2025-01-25 14:45:31.479519+00	Pelan	Jam
a0c45ba0-4687-4cf2-8122-98ba21dd1781	3	cc3d67d9-aafd-41b4-93e6-c00b588ec078	2025-01-25 14:46:10.335112+00	Sugeng	Hari
31f783dd-5f50-492a-a29b-2693d11634c7	6	cc3d67d9-aafd-41b4-93e6-c00b588ec078	2025-01-25 14:46:19.323889+00	Po	Hari
c76f1b47-3360-4fd1-83a5-3f50a7620e35	2	cc3d67d9-aafd-41b4-93e6-c00b588ec078	2025-01-25 14:47:20.811326+00	Zuuuu	Jam
a392e5fd-0384-4cff-b311-16b8ae9b618a	83	e9bec3fe-766c-41fe-a144-fcb73d705e95	2025-01-28 08:30:13.126428+00	iii999	Jam
b10de791-9a1d-4723-b0c9-f67a00894f47	70	e9bec3fe-766c-41fe-a144-fcb73d705e95	2025-01-24 13:35:52.774443+00	kio23232	Jam
615877c8-53a6-46a6-9a06-d351347e9fc8	999	e9bec3fe-766c-41fe-a144-fcb73d705e95	2025-01-29 12:10:42.752523+00	dkd	Jam
e54de8a0-fa4e-49ab-8412-97f5733ecd33	21232	cc3d67d9-aafd-41b4-93e6-c00b588ec078	2025-02-01 07:10:34.435991+00	212	Hari
70ff1f47-4bf3-40df-9f9c-86d186cefb2a	1	ca3cb819-ec42-4b13-883e-e3131abe9bb2	2025-03-07 12:43:01.829549+00	Durasi 1	Hari
c2001bfb-9702-4213-9081-1f87a16eb6c4	8	ca3cb819-ec42-4b13-883e-e3131abe9bb2	2025-03-07 13:15:53.009061+00	dask	Jam
52c40875-9d57-4b70-afe6-19fdb5e01874	8	ca3cb819-ec42-4b13-883e-e3131abe9bb2	2025-03-07 13:16:10.248295+00	ldka	Hari
1cc54691-4760-4231-a9d2-f98013bb727b	2	ca3cb819-ec42-4b13-883e-e3131abe9bb2	2025-03-07 13:17:03.558135+00	kas	Jam
1b6e4714-f790-496d-8554-6300ad8c464f	9	ca3cb819-ec42-4b13-883e-e3131abe9bb2	2025-03-07 13:17:26.384542+00	ioa	Hari
9aa76211-7fcc-407f-93b6-05f5075d583f	5	ca3cb819-ec42-4b13-883e-e3131abe9bb2	2025-03-07 13:17:41.363344+00	kas	Hari
ec2bc5b3-369b-4774-8dc5-0f06e2590b43	12	ca3cb819-ec42-4b13-883e-e3131abe9bb2	2025-03-07 13:18:25.075423+00	dlsd	Hari
4f5ce3d4-986d-4e34-97ae-d80e5bb66e9d	7	ca3cb819-ec42-4b13-883e-e3131abe9bb2	2025-03-07 13:18:41.316636+00	djs	Jam
b8ad6f38-a13a-486f-9fee-f5cbc7e2854a	81	ca3cb819-ec42-4b13-883e-e3131abe9bb2	2025-03-07 13:19:07.575206+00	iasu	Jam
f6918708-c1ad-4f8f-82b6-2b54612c3c89	3	ca3cb819-ec42-4b13-883e-e3131abe9bb2	2025-03-07 13:19:21.176658+00	dsj	Hari
82e31065-2aa3-42a8-8bea-f9b6f4c6f82c	12	361333db-632e-44b4-9192-7f4861046172	2025-03-09 14:34:27.877014+00	Cepat	Hari
c44f4d8c-2cfb-4a97-aae6-8aa94070488e	3	85239af0-2860-4e35-9f6f-5aa79a10ceb7	2025-03-16 06:08:49.695675+00	Reguler	Hari
8b85ab01-03dd-42d1-b50c-0b55668d8603	1	85239af0-2860-4e35-9f6f-5aa79a10ceb7	2025-03-16 06:08:49.695675+00	Express	Hari
b2f76778-4cff-4606-b51a-27b8d8f3bf9a	6	85239af0-2860-4e35-9f6f-5aa79a10ceb7	2025-03-16 06:08:49.695675+00	Kilat	Jam
580784cc-7a28-4b36-be39-1800dc29b2d7	3	b33dc683-b9ad-4eb6-8b38-53250b250cc6	2025-03-16 07:23:02.018489+00	Reguler	Hari
241e98f3-1e78-4893-805d-93a1ff5b3020	1	b33dc683-b9ad-4eb6-8b38-53250b250cc6	2025-03-16 07:23:02.018489+00	Express	Hari
049ea0e0-b96d-4cf4-8b7e-6e1ae6df0566	6	b33dc683-b9ad-4eb6-8b38-53250b250cc6	2025-03-16 07:23:02.018489+00	Kilat	Jam
45d1dc31-2661-419c-adef-7435d6d78e84	3	68711dbd-970a-4517-b999-1a47df6c550e	2025-03-17 11:04:06.779175+00	Reguler	Hari
eee62488-98c2-4cb8-a87e-e42e866ba3e5	1	68711dbd-970a-4517-b999-1a47df6c550e	2025-03-17 11:04:06.779175+00	Express	Hari
773f9d43-8cc5-4223-a612-179acc97d74a	6	68711dbd-970a-4517-b999-1a47df6c550e	2025-03-17 11:04:06.779175+00	Kilat	Jam
d7b81cf5-3ee6-4381-a475-68272701d889	3	9123b156-5e22-44b6-b7fa-a8c76a51f178	2025-03-17 12:55:08.283189+00	Reguler	Hari
3dfa1b5c-a0ac-4944-85d6-2bfd7979ce2d	1	9123b156-5e22-44b6-b7fa-a8c76a51f178	2025-03-17 12:55:08.283189+00	Express	Hari
a8561626-f333-4587-92fe-fd714c0ddabf	6	9123b156-5e22-44b6-b7fa-a8c76a51f178	2025-03-17 12:55:08.283189+00	Kilat	Jam
684a54b5-f6ee-4593-ab4e-fb60dabe3617	3	9e80ef92-c070-4cc5-b5f3-060f347d2c87	2025-03-19 06:52:50.030774+00	Reguler	Hari
540d2188-2486-437f-b137-087a52875efd	1	9e80ef92-c070-4cc5-b5f3-060f347d2c87	2025-03-19 06:52:50.030774+00	Express	Hari
d3f6268b-bdac-41da-b100-9e2a68b99f32	6	9e80ef92-c070-4cc5-b5f3-060f347d2c87	2025-03-19 06:52:50.030774+00	Kilat	Jam
2c2bd073-d741-432a-9325-ff7dba2b17a5	3	0fed73db-0c6d-4f95-a913-48b1131595fc	2025-03-19 07:03:24.917247+00	Reguler	Hari
7b91639e-e89f-4581-92ec-750ce30b4d8b	1	0fed73db-0c6d-4f95-a913-48b1131595fc	2025-03-19 07:03:24.917247+00	Express	Hari
8f181a7d-2634-4a6e-b589-cdf98a63fc69	6	0fed73db-0c6d-4f95-a913-48b1131595fc	2025-03-19 07:03:24.917247+00	Kilat	Jam
44528ccf-c690-4700-b842-8d5ace4e7722	3	e231be7c-213e-4500-b437-e7ed94f468a7	2025-03-19 14:08:06.83541+00	Reguler	Hari
a500410b-0563-4f68-a64d-acf30914e4f9	1	e231be7c-213e-4500-b437-e7ed94f468a7	2025-03-19 14:08:06.83541+00	Express	Hari
3acacf78-bb09-41e4-8cc5-1deef55583a9	6	e231be7c-213e-4500-b437-e7ed94f468a7	2025-03-19 14:08:06.83541+00	Kilat	Jam
03cb6f67-d2fb-4e33-bfed-d156e8fb4490	3	530de47b-18ce-4200-865f-fece556044c2	2025-03-19 22:04:24.561145+00	Reguler	Hari
51b6cadd-40f6-429d-b884-1fa05f5a39cc	1	530de47b-18ce-4200-865f-fece556044c2	2025-03-19 22:04:24.561145+00	Express	Hari
3f5217bb-d508-42e2-ac80-8f02fd1e8f32	6	530de47b-18ce-4200-865f-fece556044c2	2025-03-19 22:04:24.561145+00	Kilat	Jam
3e806c8b-ea7f-4b1c-85b4-8112f6467a6b	3	8ea1e721-d977-412f-86fb-17585368a773	2025-03-23 02:52:01.083343+00	Reguler	Hari
ef103202-4f12-48bd-961a-7467df0a37ec	1	8ea1e721-d977-412f-86fb-17585368a773	2025-03-23 02:52:01.083343+00	Express	Hari
7c5d4526-5a3c-4ac1-836c-91b70c0b1295	6	8ea1e721-d977-412f-86fb-17585368a773	2025-03-23 02:52:01.083343+00	Kilat	Jam
dc9ba10d-3b59-4b17-9610-fce7faea0289	3	7e2288a2-3004-4784-aac2-a3c2fb4155f9	2025-03-23 03:13:17.911407+00	Reguler	Hari
2e234133-efcb-4b73-8e21-824790789859	1	7e2288a2-3004-4784-aac2-a3c2fb4155f9	2025-03-23 03:13:17.911407+00	Express	Hari
66f242ad-cd8d-42d0-b5c9-37e4588591cb	6	7e2288a2-3004-4784-aac2-a3c2fb4155f9	2025-03-23 03:13:17.911407+00	Kilat	Jam
7c0742d0-524a-4dee-b994-10a0bbaf1b68	3	a2eed2f1-b740-4512-8d71-368c2df49c59	2025-03-23 04:02:29.701547+00	Reguler	Hari
e2747c95-1d1e-4f3e-be7f-347c3fd76835	1	a2eed2f1-b740-4512-8d71-368c2df49c59	2025-03-23 04:02:29.701547+00	Express	Hari
5455bcd1-904a-4f20-bddf-9de779dd2d1e	6	a2eed2f1-b740-4512-8d71-368c2df49c59	2025-03-23 04:02:29.701547+00	Kilat	Jam
ee54537a-db8c-4e21-a25c-12aa25f9c530	3	563694c4-3b7f-4a17-accd-f42f40131373	2025-04-06 02:10:23.405726+00	Reguler	Hari
609da926-00d1-4029-80df-cb2a193341ed	1	563694c4-3b7f-4a17-accd-f42f40131373	2025-04-06 02:10:23.405726+00	Express	Hari
4677c5f9-0457-4e65-b431-a83b1cfe6b35	6	563694c4-3b7f-4a17-accd-f42f40131373	2025-04-06 02:10:23.405726+00	Kilat	Jam
29193676-6d77-401f-8e7e-6cda6a19db4c	3	e32ad1af-905e-4781-86ae-389edd96ff9d	2025-04-13 10:21:02.546568+00	Reguler	Hari
16ee9718-dcfd-4218-a05d-d1a27c288ee0	1	e32ad1af-905e-4781-86ae-389edd96ff9d	2025-04-13 10:21:02.546568+00	Express	Hari
250eb0f7-9cef-415c-8cfd-3750910c4475	6	e32ad1af-905e-4781-86ae-389edd96ff9d	2025-04-13 10:21:02.546568+00	Kilat	Jam
aa6a638c-46f2-4abe-8717-e63e5c8c7713	25181	851d6597-49ca-4ec0-8ca9-2a714c68554f	2025-04-20 03:35:15.087467+00	Tes	Hari
5cc1d81b-b4c1-4698-8f9e-d062eeab2f80	3	ae3cc332-1d0e-4af9-bf90-c4047370fc63	2025-04-27 12:39:10.229862+00	Reguler	Hari
64b0e1e8-a7ad-40aa-acb4-92229588182e	1	ae3cc332-1d0e-4af9-bf90-c4047370fc63	2025-04-27 12:39:10.229862+00	Express	Hari
fc3d1971-208a-47b7-bcf5-d1625c830014	6	ae3cc332-1d0e-4af9-bf90-c4047370fc63	2025-04-27 12:39:10.229862+00	Kilat	Jam
1faff574-7239-4ac8-a923-31788aaa6452	3	d73cfd09-e4ca-415d-880b-d5944c8a04df	2025-04-27 12:44:34.319161+00	Reguler	Hari
a94697a3-f60c-4a5e-bd35-ea92332a1f25	1	d73cfd09-e4ca-415d-880b-d5944c8a04df	2025-04-27 12:44:34.319161+00	Express	Hari
8106b781-3811-457d-92c5-69b05916d3c1	6	d73cfd09-e4ca-415d-880b-d5944c8a04df	2025-04-27 12:44:34.319161+00	Kilat	Jam
cc695d2b-ad35-4632-a415-65bbde16ca70	3	ab309022-bcc9-4e04-8abc-d61c4afd3416	2025-04-29 06:42:30.746304+00	Reguler	Hari
2df9477b-dd99-44a6-b7e7-ce7b061a1b9b	1	ab309022-bcc9-4e04-8abc-d61c4afd3416	2025-04-29 06:42:30.746304+00	Express	Hari
e9363e7e-41ae-4e0c-a21b-f48f821798f5	6	ab309022-bcc9-4e04-8abc-d61c4afd3416	2025-04-29 06:42:30.746304+00	Kilat	Jam
1e2ac3b8-37cf-4a04-9120-ed3080f31c67	3	f12d64af-30ce-46bb-821e-8dd6b9eec514	2025-05-01 14:30:59.616206+00	Reguler	Hari
6c25d1d5-277d-4ac0-b46a-57325e6b6580	1	f12d64af-30ce-46bb-821e-8dd6b9eec514	2025-05-01 14:30:59.616206+00	Express	Hari
5ddf6e81-eb80-4e38-8a98-a49508d21ba0	6	f12d64af-30ce-46bb-821e-8dd6b9eec514	2025-05-01 14:30:59.616206+00	Kilat	Jam
179c3255-8ad1-4cb7-8414-686014f1547b	3	a145d8a1-8899-4a15-90a2-bc20da194e04	2025-05-01 14:42:42.602641+00	Reguler	Hari
17f23519-e029-43bc-a8c2-1ea75c6217a7	1	a145d8a1-8899-4a15-90a2-bc20da194e04	2025-05-01 14:42:42.602641+00	Express	Hari
53f467de-a833-4896-a91d-03532318d63d	6	a145d8a1-8899-4a15-90a2-bc20da194e04	2025-05-01 14:42:42.602641+00	Kilat	Jam
5c42b913-6aa7-49e0-90ca-05525bb0ed3a	3	b1b00121-0f27-43b2-aa80-5d2094bfff62	2025-05-01 14:44:04.795594+00	Reguler	Hari
286d5002-e006-4f55-96c9-25fecd5327e1	1	b1b00121-0f27-43b2-aa80-5d2094bfff62	2025-05-01 14:44:04.795594+00	Express	Hari
fe7256ac-3d99-457c-b100-839e96aacc2e	6	b1b00121-0f27-43b2-aa80-5d2094bfff62	2025-05-01 14:44:04.795594+00	Kilat	Jam
a0d3182c-b5f1-4162-a35e-18d89206cbed	3	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	2025-05-01 14:44:44.123883+00	Reguler	Hari
7fb6c313-652d-40ec-b28d-d5823b591607	1	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	2025-05-01 14:44:44.123883+00	Express	Hari
2238403b-11f9-481d-b773-9d38f9c49619	6	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	2025-05-01 14:44:44.123883+00	Kilat	Jam
28150363-d0b0-4636-a997-dfa79defc28e	3	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	2025-05-01 14:48:09.342027+00	Reguler	Hari
d0f9d176-b106-493a-afe2-7dfe45d8f605	1	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	2025-05-01 14:48:09.342027+00	Express	Hari
3b628d15-2730-4750-9054-dca82c9dde6c	6	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	2025-05-01 14:48:09.342027+00	Kilat	Jam
2a41b979-cc7b-4e77-9090-2582771c1052	3	8be70116-5bc2-4a51-a3b5-5001739899ae	2025-05-01 15:07:25.412782+00	Reguler	Hari
fb00477f-05c8-4ae2-a1fe-c779d7d2cbfb	1	8be70116-5bc2-4a51-a3b5-5001739899ae	2025-05-01 15:07:25.412782+00	Express	Hari
3d1f42e3-373b-404a-8da1-5d7aa2437f29	6	8be70116-5bc2-4a51-a3b5-5001739899ae	2025-05-01 15:07:25.412782+00	Kilat	Jam
e517f045-c842-49c7-9bd0-4abe013d9c65	3	ff9c0083-6186-40e8-b24a-0801bec4e4f4	2025-05-04 07:08:58.165851+00	Reguler	Hari
09315f6e-99f4-4389-9e74-0628aa80bf91	1	ff9c0083-6186-40e8-b24a-0801bec4e4f4	2025-05-04 07:08:58.165851+00	Express	Hari
58151107-6253-454c-b172-8dcd31e06f8e	6	ff9c0083-6186-40e8-b24a-0801bec4e4f4	2025-05-04 07:08:58.165851+00	Kilat	Jam
22bbf7be-fb55-452e-8d47-047d4a27136a	3	490e65e1-0159-4a63-855c-b3ed8e621ef4	2025-05-21 03:00:59.278422+00	Reguler	Hari
72f7e902-ac44-4713-8222-9e805e04de6f	1	490e65e1-0159-4a63-855c-b3ed8e621ef4	2025-05-21 03:00:59.278422+00	Express	Hari
aafbad3c-bf5e-4a54-876d-c5be25856217	6	490e65e1-0159-4a63-855c-b3ed8e621ef4	2025-05-21 03:00:59.278422+00	Kilat	Jam
60b2f947-a1e4-4f02-93be-857b737e0aae	3	9d659c1f-c68f-4f69-9e21-fbcf37432bab	2025-05-25 13:38:03.846639+00	Reguler	Hari
4f12960f-3ff9-4471-a4be-9558f2cdaf24	1	9d659c1f-c68f-4f69-9e21-fbcf37432bab	2025-05-25 13:38:03.846639+00	Express	Hari
f431deb8-0d2f-4b10-88c2-eacc6e840490	6	9d659c1f-c68f-4f69-9e21-fbcf37432bab	2025-05-25 13:38:03.846639+00	Kilat	Jam
6f94f581-3f5b-4f59-b374-26b0472a636b	3	704b9e26-e5ce-4f92-9b5d-ded4eecace01	2025-06-14 11:16:09.71107+00	Reguler	Hari
f27dc843-7b3f-4399-9fda-8f030acd3723	1	704b9e26-e5ce-4f92-9b5d-ded4eecace01	2025-06-14 11:16:09.71107+00	Express	Hari
41f44fb3-7e42-4cab-bf75-8ae3ec46a89b	6	704b9e26-e5ce-4f92-9b5d-ded4eecace01	2025-06-14 11:16:09.71107+00	Kilat	Jam
0d32680c-8e07-445b-b6d1-daa522ef21f2	3	5f892fcb-c56a-4059-ba66-e581e45e3a67	2025-06-14 11:30:20.804019+00	Reguler	Hari
884c9b2e-7969-4ed1-b07c-be130c75e8c3	1	5f892fcb-c56a-4059-ba66-e581e45e3a67	2025-06-14 11:30:20.804019+00	Express	Hari
0abbf487-b975-410a-a8cc-00297a719c31	6	5f892fcb-c56a-4059-ba66-e581e45e3a67	2025-06-14 11:30:20.804019+00	Kilat	Jam
08e9d990-a63d-41c7-9fcc-327cbe5f9254	3	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	2025-06-14 11:46:02.198027+00	Reguler	Hari
f3d5a4ea-1eae-42bf-8b5e-722f14c13042	1	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	2025-06-14 11:46:02.198027+00	Express	Hari
07394679-0e00-4615-b54c-7f256f0819b0	6	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	2025-06-14 11:46:02.198027+00	Kilat	Jam
1939d1a5-28aa-4e56-9ee7-1c75fe8fce7d	3	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	2025-06-14 11:48:28.089577+00	Reguler	Hari
4a3525e4-0dc5-4baf-a74f-c756eab654ee	1	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	2025-06-14 11:48:28.089577+00	Express	Hari
ca84efee-efb3-4890-8bd9-66a0a6aacd6d	6	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	2025-06-14 11:48:28.089577+00	Kilat	Jam
ff0013fb-fa28-4e5b-a56a-3dd13c232ae0	3	3cf34541-51de-42f8-9c16-5b95020d9fff	2025-06-14 11:49:25.638803+00	Reguler	Hari
95451032-e8b9-42e6-b2a0-a8b996cf57eb	1	3cf34541-51de-42f8-9c16-5b95020d9fff	2025-06-14 11:49:25.638803+00	Express	Hari
b9d4123f-5e0a-430e-a18d-8d9abc8068c6	6	3cf34541-51de-42f8-9c16-5b95020d9fff	2025-06-14 11:49:25.638803+00	Kilat	Jam
14916f75-0143-4bee-b423-6c90274fc4fe	3	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	2025-06-15 03:16:52.249521+00	Reguler	Hari
e4ec5b31-a011-44ae-8131-d71fef68b6b2	1	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	2025-06-15 03:16:52.249521+00	Express	Hari
dc0ed58d-3580-4ee8-ba3e-5f38d2d0a19a	6	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	2025-06-15 03:16:52.249521+00	Kilat	Jam
d7c97574-2033-44fe-aeea-27c42d4c3cd1	3	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	2025-06-15 03:18:59.694843+00	Reguler	Hari
17f7c8db-f32d-4b27-b591-f390d4e6de5d	1	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	2025-06-15 03:18:59.694843+00	Express	Hari
151315ce-f550-40f4-9ead-d73e8d379f73	6	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	2025-06-15 03:18:59.694843+00	Kilat	Jam
ca9366e2-0d85-420c-a757-40e22dedb68c	3	ddc18a20-f5e5-48d3-a94d-9febac756a86	2025-06-15 03:20:21.276696+00	Reguler	Hari
13600809-d7f4-437e-976e-0ba6a3c1105b	1	ddc18a20-f5e5-48d3-a94d-9febac756a86	2025-06-15 03:20:21.276696+00	Express	Hari
6c9fcc44-729c-4d13-b24c-0078a02c426c	6	ddc18a20-f5e5-48d3-a94d-9febac756a86	2025-06-15 03:20:21.276696+00	Kilat	Jam
d157f3d2-15a9-4980-a415-54e60a1eab3c	3	8bd96235-350d-4f6f-9489-3f80122e1c77	2025-06-15 03:26:37.883854+00	Reguler	Hari
e5438a93-f9cf-4d79-a20e-eda85f191a6b	1	8bd96235-350d-4f6f-9489-3f80122e1c77	2025-06-15 03:26:37.883854+00	Express	Hari
4e42b7ac-5287-429c-983a-fb1defd8aa6d	6	8bd96235-350d-4f6f-9489-3f80122e1c77	2025-06-15 03:26:37.883854+00	Kilat	Jam
2c1d83ff-93d7-4f90-85f1-2bf004a22643	3	eea90897-1470-4ff5-a32d-cabb71375c9e	2025-06-15 12:21:35.856241+00	Reguler	Hari
32a4579c-9cee-49c0-8be6-67274b5ab04d	1	eea90897-1470-4ff5-a32d-cabb71375c9e	2025-06-15 12:21:35.856241+00	Express	Hari
6b9df17f-67f6-44f2-9ed3-19a993e50203	6	eea90897-1470-4ff5-a32d-cabb71375c9e	2025-06-15 12:21:35.856241+00	Kilat	Jam
914af688-3621-471b-86d2-613a793511a6	3	1ad21901-807d-4aa4-80d4-640876d4faab	2025-06-15 12:59:20.039467+00	Reguler	Hari
dae7d0aa-7898-4ea7-b8ae-50dff6d6122b	1	1ad21901-807d-4aa4-80d4-640876d4faab	2025-06-15 12:59:20.039467+00	Express	Hari
6324cdb5-ba69-4eef-bb04-6c248c1ceed3	6	1ad21901-807d-4aa4-80d4-640876d4faab	2025-06-15 12:59:20.039467+00	Kilat	Jam
c46ed9e9-a61b-4f06-9352-121791f69d9c	3	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	2025-06-15 13:01:09.714034+00	Reguler	Hari
93b34904-0165-4e45-96ba-934dd6cb85f5	1	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	2025-06-15 13:01:09.714034+00	Express	Hari
3b3265e3-0c91-45cf-9686-f9abc1d28420	6	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	2025-06-15 13:01:09.714034+00	Kilat	Jam
43fe47b2-4241-4b71-8ef1-e0bc5679be95	3	b54508fb-9003-4919-93e3-096d0b87f9a8	2025-06-16 14:43:24.217119+00	Reguler	Hari
ca89f6b7-09f0-4976-8a59-a0f0003d33b9	1	b54508fb-9003-4919-93e3-096d0b87f9a8	2025-06-16 14:43:24.217119+00	Express	Hari
be775625-f185-4a61-bab2-d1960ab9d299	6	b54508fb-9003-4919-93e3-096d0b87f9a8	2025-06-16 14:43:24.217119+00	Kilat	Jam
e4f5dedd-3256-49a5-9616-d66aea786692	3	0a78c027-5af9-4360-9ffb-c4b89ada5fdb	2025-07-07 15:47:09.223472+00	Reguler	Hari
bb84644d-b0a2-431e-8aa1-4c86eb028f6a	1	0a78c027-5af9-4360-9ffb-c4b89ada5fdb	2025-07-07 15:47:09.223472+00	Express	Hari
9a4a0732-9cb1-4d86-82d9-b8da6ce8f1ba	6	0a78c027-5af9-4360-9ffb-c4b89ada5fdb	2025-07-07 15:47:09.223472+00	Kilat	Jam
399fda41-db45-47c8-9427-87211f005799	3	2003c690-4cf7-46cb-9362-2f6c2d911db7	2025-07-07 15:52:34.649154+00	Reguler	Hari
41ed5c1b-6152-4627-a975-e45516661bad	1	2003c690-4cf7-46cb-9362-2f6c2d911db7	2025-07-07 15:52:34.649154+00	Express	Hari
c4ef3627-a78b-4eb2-a2e6-ffe43e3657aa	6	2003c690-4cf7-46cb-9362-2f6c2d911db7	2025-07-07 15:52:34.649154+00	Kilat	Jam
7969a2ea-01d6-4b93-a621-4894087f038e	3	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	2025-07-07 15:53:35.479432+00	Reguler	Hari
10697aed-f25b-4946-92b0-cbc6eede5738	1	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	2025-07-07 15:53:35.479432+00	Express	Hari
3e588837-472e-48ef-a8f2-5d6947777333	6	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	2025-07-07 15:53:35.479432+00	Kilat	Jam
a530e441-da5b-406d-8b02-24c5a84df009	3	7e214247-26dc-49cc-af5e-48926de89be6	2025-07-07 15:55:46.553254+00	Reguler	Hari
dc7c1a05-41c8-4db7-b5e6-2839979e8afd	1	7e214247-26dc-49cc-af5e-48926de89be6	2025-07-07 15:55:46.553254+00	Express	Hari
3ccb4563-f802-4c48-9bea-94d47cc8a655	6	7e214247-26dc-49cc-af5e-48926de89be6	2025-07-07 15:55:46.553254+00	Kilat	Jam
83de63a1-806c-44b8-93ac-008b67936d9d	3	1c5e12f4-a59a-4838-83cc-bf399f5b9221	2025-07-07 15:57:48.951669+00	Reguler	Hari
0a504ac5-d2cc-4767-9de4-377d7e5a36b3	1	1c5e12f4-a59a-4838-83cc-bf399f5b9221	2025-07-07 15:57:48.951669+00	Express	Hari
9d06e6e7-1ebb-44f9-bd64-75daa260baaa	6	1c5e12f4-a59a-4838-83cc-bf399f5b9221	2025-07-07 15:57:48.951669+00	Kilat	Jam
13aa807b-7bef-4c39-80c4-180e0a9142e5	3	a7d92f73-5755-49a1-971c-5e14c1d47a31	2025-07-07 16:03:08.483403+00	Reguler	Hari
cea68088-696f-4107-adcd-90afb20b4b09	1	a7d92f73-5755-49a1-971c-5e14c1d47a31	2025-07-07 16:03:08.483403+00	Express	Hari
28bac44d-85c7-4cd5-aa9c-81083b4451dc	6	a7d92f73-5755-49a1-971c-5e14c1d47a31	2025-07-07 16:03:08.483403+00	Kilat	Jam
214c3961-54aa-4402-828e-9bf97523207e	3	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	2025-07-12 05:40:22.296645+00	Reguler	Hari
a5e60f66-46bc-4eb2-b394-7b6177f9e8d5	1	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	2025-07-12 05:40:22.296645+00	Express	Hari
680f103d-bcbf-4c7a-8d69-707756b1cda8	6	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	2025-07-12 05:40:22.296645+00	Kilat	Jam
ca9b4d87-89bd-4ff9-9da5-d4b2f81db5e8	3	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	2025-07-12 05:52:39.653711+00	Reguler	Hari
158250da-8379-4ed5-95c3-10e661ac4c16	1	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	2025-07-12 05:52:39.653711+00	Express	Hari
4ab6a96b-3fa9-4b86-80b8-b28f98508d00	6	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	2025-07-12 05:52:39.653711+00	Kilat	Jam
6530a546-9034-4b36-93c9-95ac1802cc83	3	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	2025-07-12 06:03:31.332654+00	Reguler	Hari
f8f146c2-5dfc-48a4-977e-9021fab251d6	1	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	2025-07-12 06:03:31.332654+00	Express	Hari
f983a28b-7239-4935-a15e-aec4c7dfaf38	6	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	2025-07-12 06:03:31.332654+00	Kilat	Jam
3b798880-5548-40af-80b9-12382a77e6cd	3	18184643-ccb7-4f42-aa82-d423445bcf3d	2025-07-13 07:23:38.406043+00	Reguler	Hari
70957997-7a11-4645-82c4-714b44e2c321	1	18184643-ccb7-4f42-aa82-d423445bcf3d	2025-07-13 07:23:38.406043+00	Express	Hari
eff8b578-211e-4540-b148-3c33063239d4	6	18184643-ccb7-4f42-aa82-d423445bcf3d	2025-07-13 07:23:38.406043+00	Kilat	Jam
f45b2650-669f-4d04-b8c6-81830d988284	3	e128e7f5-d6b1-4895-98d0-84583540da63	2025-07-20 03:20:17.020718+00	Reguler	Hari
abb53ff1-92dd-4079-ac2f-8205bca374be	1	e128e7f5-d6b1-4895-98d0-84583540da63	2025-07-20 03:20:17.020718+00	Express	Hari
39f5045c-cc86-48b8-bcdd-4681eec42144	6	e128e7f5-d6b1-4895-98d0-84583540da63	2025-07-20 03:20:17.020718+00	Kilat	Jam
00998bcc-3c17-4102-981b-0e18308bb006	3	7728b222-a096-4da0-96af-0b7934f8b9ba	2025-07-20 03:27:11.149442+00	Reguler	Hari
8460ed64-8915-4171-917d-d4e97d087dfb	1	7728b222-a096-4da0-96af-0b7934f8b9ba	2025-07-20 03:27:11.149442+00	Express	Hari
5a3314a6-356e-47a4-8ffe-18d50e4ec219	6	7728b222-a096-4da0-96af-0b7934f8b9ba	2025-07-20 03:27:11.149442+00	Kilat	Jam
9c600ebe-2492-46dd-85c4-4842111ce368	3	d9453749-87fb-469d-a93a-22a577b0e98b	2025-08-05 14:27:20.893026+00	Reguler	Hari
6e2a55ef-2bf7-4bed-a467-15e06b303784	1	d9453749-87fb-469d-a93a-22a577b0e98b	2025-08-05 14:27:20.893026+00	Express	Hari
991418de-6b30-42e5-a925-3d1c8b780d91	6	d9453749-87fb-469d-a93a-22a577b0e98b	2025-08-05 14:27:20.893026+00	Kilat	Jam
a8b8dc72-4c30-478b-b827-e500a95db888	3	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	2025-08-12 13:48:13.33748+00	Reguler	Hari
bf6ad88d-d3ff-4512-96d2-2d7172705476	1	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	2025-08-12 13:48:13.33748+00	Express	Hari
030422b5-cf6d-4a40-b80f-28c12f8c8293	6	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	2025-08-12 13:48:13.33748+00	Kilat	Jam
3eba38de-0141-45a7-9c49-6fb86f38fb9c	3	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	2025-08-13 14:40:58.813166+00	Jjj	Hari
6292d8a9-af15-46be-837f-f9bd7840e0cf	1	fe4e3388-40d9-422a-8140-a5a21ab56fbb	2025-08-26 13:33:51.993261+00	Express	Hari
50be6b4e-2cef-499c-a660-6293a8f512bc	3	20a1b60b-2c45-4533-a02e-ad9d4545b860	2025-12-26 02:01:09.782052+00	Reguler	Hari
af902c02-c6c2-47c5-addc-8f0ca2972104	1	20a1b60b-2c45-4533-a02e-ad9d4545b860	2025-12-26 02:01:09.782052+00	Express	Hari
bcc7536c-ac41-4390-8541-69d1b2bc29c6	6	20a1b60b-2c45-4533-a02e-ad9d4545b860	2025-12-26 02:01:09.782052+00	Kilat	Jam
fa0d48e7-5cd6-48eb-af16-161d1dcadc36	3	3d57f37f-755f-42b5-a3a4-9de23314881a	2025-12-26 02:08:36.207421+00	Reguler	Hari
805c56df-8629-4e4a-bab7-9a044c30877f	1	3d57f37f-755f-42b5-a3a4-9de23314881a	2025-12-26 02:08:36.207421+00	Express	Hari
5866513f-d9b3-400b-989c-00b0e1eb3b75	62	fe4e3388-40d9-422a-8140-a5a21ab56fbb	2025-08-26 13:33:51.993261+00	Kilat 12	Jam
0ddbfd98-2b84-4b3c-87f5-60a0273c4c8e	322	fe4e3388-40d9-422a-8140-a5a21ab56fbb	2025-08-26 13:33:51.993261+00	Reguler wy	Hari
e231c43a-ddd1-4e77-b60e-34f180f00ba3	6	3d57f37f-755f-42b5-a3a4-9de23314881a	2025-12-26 02:08:36.207421+00	Kilat	Jam
6015168c-055c-455e-b685-40b452247c32	3	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	2025-12-26 02:09:09.744311+00	Reguler	Hari
c121a481-7d6e-4e1b-a4eb-9b40a00d8511	6	fe4e3388-40d9-422a-8140-a5a21ab56fbb	2025-09-04 15:32:21.700335+00	baru	Hari
246bb5f2-aba9-4073-a1e3-d070171f6871	1	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	2025-12-26 02:09:09.744311+00	Express	Hari
bb8d886d-f770-4eb7-82fa-dcd254d39e8a	3	7aefc064-bbad-40cc-b31e-645c90c9116c	2025-09-09 15:02:17.017864+00	Reguler	Hari
5fae84c4-610b-42a0-9e31-a6eb2ff9e951	1	7aefc064-bbad-40cc-b31e-645c90c9116c	2025-09-09 15:02:17.017864+00	Express	Hari
40f05a5f-f197-4de4-831e-96b4a6126eec	1	7aefc064-bbad-40cc-b31e-645c90c9116c	2025-09-09 15:02:17.017864+00	Kilat	Jam
abf8147b-eeed-479b-bb20-2bb07dbc6a17	3	f048badd-8538-46fe-bd12-ddfaa30646b2	2025-09-23 00:42:12.596764+00	Reguler	Hari
19e1c045-6bc6-49f6-b8e8-4b43f5b33fa5	1	f048badd-8538-46fe-bd12-ddfaa30646b2	2025-09-23 00:42:12.596764+00	Express	Hari
b271cdb1-db86-4bec-88ee-aa7c3a1695d1	6	f048badd-8538-46fe-bd12-ddfaa30646b2	2025-09-23 00:42:12.596764+00	Kilat	Jam
f9e92872-603a-4a2f-a0c2-617ab0472d4b	1	8db3f967-5f09-4150-a95b-010faa31a22a	2025-09-23 12:04:44.747711+00	Express	Hari
abee1f7a-f067-496c-a5c8-8d2832a7427f	2	8db3f967-5f09-4150-a95b-010faa31a22a	2025-10-01 13:25:03.241717+00	Cek	Jam
602ab505-edce-4260-aa7a-81ff3910e901	2	\N	2025-10-20 13:55:19.681448+00	test	Jam
8509068c-dbdc-477a-8459-9c5656971747	3	9e9f89b7-0659-411f-b06d-d75bff0eb648	2025-11-10 12:03:00.974657+00	Reguler	Hari
810c228e-d9ce-43db-98bf-d7d521a5f5ba	1	9e9f89b7-0659-411f-b06d-d75bff0eb648	2025-11-10 12:03:00.974657+00	Express	Hari
c43ae7c1-3432-47de-9f17-a1ae54d0bdbd	6	9e9f89b7-0659-411f-b06d-d75bff0eb648	2025-11-10 12:03:00.974657+00	Kilat	Jam
049f7adf-d1fa-465f-bf3e-8fef5a519ff4	3	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	2025-11-10 12:08:21.837634+00	Reguler	Hari
d4de3459-36f0-40ee-834a-3f709006c12c	1	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	2025-11-10 12:08:21.837634+00	Express	Hari
b25a9aee-f026-42d2-98bd-ff4ad1997200	6	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	2025-11-10 12:08:21.837634+00	Kilat	Jam
b61ace1f-1e5a-4e65-bb8f-b7d90fdc940a	3	83731f63-30af-4793-be22-43d9b622e7d4	2025-11-10 14:31:44.007636+00	Reguler	Hari
76eb6646-9c87-4026-a9ca-450eed5f06af	1	83731f63-30af-4793-be22-43d9b622e7d4	2025-11-10 14:31:44.007636+00	Express	Hari
8e13ff4b-20dc-4b99-ac37-90d1989820db	6	83731f63-30af-4793-be22-43d9b622e7d4	2025-11-10 14:31:44.007636+00	Kilat	Jam
7cb26104-2032-4d69-91db-abe03a61dcf6	3	6fed4540-3689-4ee4-837d-614174568f7d	2025-11-12 23:20:09.904204+00	Reguler	Hari
2ab15ba5-1727-4636-866f-22037a50e3e6	1	6fed4540-3689-4ee4-837d-614174568f7d	2025-11-12 23:20:09.904204+00	Express	Hari
8d5838e1-0f55-4e14-a54f-91ccc4f210e7	6	6fed4540-3689-4ee4-837d-614174568f7d	2025-11-12 23:20:09.904204+00	Kilat	Jam
afd609b8-0b82-4161-89eb-45db45c4a410	6	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	2025-12-26 02:09:09.744311+00	Kilat	Jam
a0236724-49ec-4f77-b5b4-7f0faba0e7d7	3	40b66b3d-ca74-414c-8879-3318ab49ce38	2025-12-29 13:47:33.752859+00	Reguler	Hari
1a410093-18cc-46f7-9c14-28c356ac75c3	3	8db3f967-5f09-4150-a95b-010faa31a22a	2025-09-23 12:04:44.747711+00	Reguler	Hari
0d031481-e6c6-4f1c-bc0f-e7e552df1a91	1	40b66b3d-ca74-414c-8879-3318ab49ce38	2025-12-29 13:47:33.752859+00	Express	Hari
80f52e3a-797a-4b86-a660-9b60f93d7681	6	40b66b3d-ca74-414c-8879-3318ab49ce38	2025-12-29 13:47:33.752859+00	Kilat	Jam
99a0e713-2045-44d8-a222-728f1d81446f	3	d74b18af-dd09-42f1-97c6-1286fb33604c	2025-12-29 13:56:31.2994+00	Reguler	Hari
7560b232-73ff-4912-9f6a-10602d0ad2b1	1	d74b18af-dd09-42f1-97c6-1286fb33604c	2025-12-29 13:56:31.2994+00	Express	Hari
26dbce97-4e72-4e4c-83a2-2b06c6834dc0	32	8db3f967-5f09-4150-a95b-010faa31a22a	2025-09-23 12:04:44.747711+00	Kilat	Jam
de9a4094-e682-4f13-912d-6255e998990f	2	8db3f967-5f09-4150-a95b-010faa31a22a	2025-12-10 12:30:15.706996+00	baru	Hari
2d285880-7229-48db-8f57-44b54813698c	6	d74b18af-dd09-42f1-97c6-1286fb33604c	2025-12-29 13:56:31.2994+00	Kilat	Jam
79798fa5-eca2-4925-bb82-6be3e500fc56	3	9673cd3f-9374-4ecc-a569-d750f3f3ff34	2025-12-29 14:01:00.127012+00	Reguler	Hari
6aaa8849-c700-4c7f-8868-3e15c999c764	26	8db3f967-5f09-4150-a95b-010faa31a22a	2025-12-11 14:03:32.251806+00	uuuu	Hari
7e6846dd-78c8-4c65-bbe9-0df70e15e316	1	9673cd3f-9374-4ecc-a569-d750f3f3ff34	2025-12-29 14:01:00.127012+00	Express	Hari
c9cc4f8a-fe6c-495c-8607-01d81f199d19	3	8db3f967-5f09-4150-a95b-010faa31a22a	2025-12-11 14:04:34.875601+00	iiiuyyy	Hari
329b1676-cc02-406f-b4e4-6cf5770f1099	5	8db3f967-5f09-4150-a95b-010faa31a22a	2025-12-11 14:02:02.707503+00	bs	Jam
88334bd5-1272-442d-9485-ed1f4700aa93	2	8db3f967-5f09-4150-a95b-010faa31a22a	2025-12-22 12:14:47.604742+00	ffhhh	Hari
5a1a4a15-4f65-4bf4-96fd-516bea2d231a	3	acb4da41-865e-40d9-a330-070c0a2b88c8	2025-12-24 11:58:58.634635+00	Reguler	Hari
7d104b0e-2c49-412f-a87c-90c7f8212679	1	acb4da41-865e-40d9-a330-070c0a2b88c8	2025-12-24 11:58:58.634635+00	Express	Hari
ac36a51e-231b-4e10-ad26-1c368b67f3c1	6	acb4da41-865e-40d9-a330-070c0a2b88c8	2025-12-24 11:58:58.634635+00	Kilat	Jam
b77a9478-b992-46c5-8525-7dbd810b861e	3	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	2025-12-24 12:05:47.624747+00	Reguler	Hari
003e5e86-44de-43c4-a6cf-297105572276	1	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	2025-12-24 12:05:47.624747+00	Express	Hari
e27f79a4-4293-455b-adcc-b9ea6f4bc1ff	6	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	2025-12-24 12:05:47.624747+00	Kilat	Jam
a1224d64-4c38-4cea-84a5-393afba2bc2d	3	dd479ee9-79bd-4642-b46a-d87f97446a78	2025-12-24 12:09:41.331645+00	Reguler	Hari
19b18fd4-0887-418a-9a40-df3a476f25e5	1	dd479ee9-79bd-4642-b46a-d87f97446a78	2025-12-24 12:09:41.331645+00	Express	Hari
7932cbf9-8ba8-470d-940d-a9c7054b5091	6	dd479ee9-79bd-4642-b46a-d87f97446a78	2025-12-24 12:09:41.331645+00	Kilat	Jam
96d809da-8a60-494e-a923-0f851dc095ec	3	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	2025-12-24 12:15:35.563358+00	Reguler	Hari
bca9722f-c8d2-43ad-b8bb-c34f57cff0da	1	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	2025-12-24 12:15:35.563358+00	Express	Hari
0a933314-040b-4b51-bd6f-ee8f0e9a2167	6	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	2025-12-24 12:15:35.563358+00	Kilat	Jam
2a098950-d5a1-499a-8cc6-4f36e6bda64c	6	9673cd3f-9374-4ecc-a569-d750f3f3ff34	2025-12-29 14:01:00.127012+00	Kilat	Jam
587712b4-77d7-4c30-988a-723a5b7695dd	3	ba472db5-f09a-48c3-b6c9-e3233acfc46f	2025-12-29 14:02:53.837645+00	Reguler	Hari
c88faf7d-86fa-4965-b72c-4e2362726cd0	1	ba472db5-f09a-48c3-b6c9-e3233acfc46f	2025-12-29 14:02:53.837645+00	Express	Hari
b35f4309-d4c3-4e75-ac46-cd12a807f08a	6	ba472db5-f09a-48c3-b6c9-e3233acfc46f	2025-12-29 14:02:53.837645+00	Kilat	Jam
042a9a56-7188-4367-9b59-9cd1ca25fc55	3	3d54010f-5655-4c05-bed1-4984d5347c93	2025-12-29 14:04:59.02137+00	Reguler	Hari
4c52122a-4587-4e5f-9671-520ffc530de7	1	3d54010f-5655-4c05-bed1-4984d5347c93	2025-12-29 14:04:59.02137+00	Express	Hari
b9186c6a-497a-41b2-a4e2-e456bf8ed725	6	3d54010f-5655-4c05-bed1-4984d5347c93	2025-12-29 14:04:59.02137+00	Kilat	Jam
981e7f2e-04b2-410a-a724-3311924abeb7	3	6e56ab91-182b-4f44-b226-d1f0dc289423	2026-02-21 07:39:47.200396+00	Reguler	Hari
4b8257b7-e364-44c4-806a-c462d9412656	1	6e56ab91-182b-4f44-b226-d1f0dc289423	2026-02-21 07:39:47.200396+00	Express	Hari
d7a147d9-f6e8-4ca3-979d-f2bc83da03f2	6	6e56ab91-182b-4f44-b226-d1f0dc289423	2026-02-21 07:39:47.200396+00	Kilat	Jam
afc942c2-4267-4e8e-bd9d-9ef94318e690	3	579c0264-e4bf-4cac-881d-2d3aa5fff59d	2026-02-21 07:40:46.243271+00	Reguler	Hari
2c125ada-d5ac-46d2-a0ae-0692f3614dbe	1	579c0264-e4bf-4cac-881d-2d3aa5fff59d	2026-02-21 07:40:46.243271+00	Express	Hari
b254fa16-6a50-47a8-8541-89b74e743510	6	579c0264-e4bf-4cac-881d-2d3aa5fff59d	2026-02-21 07:40:46.243271+00	Kilat	Jam
361d4ddd-5fa5-48bb-93f8-b2c961c499a6	3	8d468ffc-f533-48ba-8c6b-285d63647a99	2026-02-21 07:41:12.842216+00	Reguler	Hari
a1aec9c7-f06f-47c5-a6ae-f7e94fdf60bf	1	8d468ffc-f533-48ba-8c6b-285d63647a99	2026-02-21 07:41:12.842216+00	Express	Hari
9fd5d020-98ef-413c-84f0-d9a7f50cf611	6	8d468ffc-f533-48ba-8c6b-285d63647a99	2026-02-21 07:41:12.842216+00	Kilat	Jam
ff9c402f-c5ee-4a69-a02b-248cf1f0e89a	3	65e7caf4-1316-49da-a3b9-3b7f8fef3955	2026-02-21 07:41:28.499124+00	Reguler	Hari
238cf216-0a1e-4f8f-8897-a5aa0d8f45c9	1	65e7caf4-1316-49da-a3b9-3b7f8fef3955	2026-02-21 07:41:28.499124+00	Express	Hari
a572230f-4f02-4842-9d9e-0fc60ae77323	6	65e7caf4-1316-49da-a3b9-3b7f8fef3955	2026-02-21 07:41:28.499124+00	Kilat	Jam
03851633-508b-45e9-84da-e9efba545cf7	3	cf7cfef7-6850-46c2-9efc-22c28cb0922c	2026-02-22 12:46:24.072509+00	Reguler	Hari
87966686-2950-42a4-af9a-4bad571ae99e	1	cf7cfef7-6850-46c2-9efc-22c28cb0922c	2026-02-22 12:46:24.072509+00	Express	Hari
f282fceb-30f0-4425-813c-5cf5154a8cad	6	cf7cfef7-6850-46c2-9efc-22c28cb0922c	2026-02-22 12:46:24.072509+00	Kilat	Jam
af3c79e4-2b9d-4ea8-a86a-8861fd55dcf0	3	4b843f69-8041-4846-8af4-872de4c5c41e	2026-02-27 22:29:07.835999+00	Reguler	Hari
25514e6f-69be-4143-aa4c-20baef759bf4	1	4b843f69-8041-4846-8af4-872de4c5c41e	2026-02-27 22:29:07.835999+00	Express	Hari
0ff0dd0a-03fd-4110-87fc-a14f44ca876d	6	4b843f69-8041-4846-8af4-872de4c5c41e	2026-02-27 22:29:07.835999+00	Kilat	Jam
59190cee-30b0-48da-a5a4-9bd23df8b5d6	12	3d54010f-5655-4c05-bed1-4984d5347c93	2026-03-01 09:09:43.76886+00	test	Jam
\.


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.expenses (id, merchant_id, total, description, date, created_at) FROM stdin;
5	9d659c1f-c68f-4f69-9e21-fbcf37432bab	2500.00	Tttt	2026-02-04	2026-02-24 13:52:35.345623+00
7	9d659c1f-c68f-4f69-9e21-fbcf37432bab	25555.00	Ttttt	2026-02-04	2026-02-24 14:24:43.677099+00
6	9d659c1f-c68f-4f69-9e21-fbcf37432bab	255533.00	Fffgggoo9o	2026-02-12	2026-02-24 14:19:25.315093+00
8	9d659c1f-c68f-4f69-9e21-fbcf37432bab	10000.00	ss	2026-02-01	2026-02-26 09:11:19.354385+00
9	9d659c1f-c68f-4f69-9e21-fbcf37432bab	25000.00	Ok	2026-02-26	2026-02-26 09:17:40.764955+00
10	4b843f69-8041-4846-8af4-872de4c5c41e	2000.00	Test	2026-02-12	2026-02-27 22:46:24.945635+00
11	9d659c1f-c68f-4f69-9e21-fbcf37432bab	10000.00	ss	2026-02-01	2026-03-09 16:42:58.474381+00
12	9d659c1f-c68f-4f69-9e21-fbcf37432bab	20500.00	Cek	2026-03-10	2026-03-10 23:21:00.054821+00
\.


--
-- Data for Name: note; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.note (merchant_id, notes, id, created_at) FROM stdin;
8db3f967-5f09-4150-a95b-010faa31a22a	1. Ok\n2. Wawan\n3. Jon\nIhiggffhjghhgggffggjjhghchhh\nHh ipul	490a3e7a-5b68-4498-b66c-9f5a3e366307	2025-11-10 14:29:13.800323+00
568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	<string>	faf5c741-5138-4677-9c52-3217852962a0	2024-11-11 13:38:38.229077+00
99eea1df-1d39-4fae-a8ca-65e71349b34c	1. joj\n2. jij\n3. kl	05a2b9d9-4173-456a-b9cb-be930ad752d6	2025-01-19 01:19:01.463905+00
cc3d67d9-aafd-41b4-93e6-c00b588ec078	1. Ok\n2. \n3. 	9c72231b-6714-4954-9a17-bc65c3ce363b	2025-01-25 14:49:20.769974+00
e9bec3fe-766c-41fe-a144-fcb73d705e95	1. iiiooo\n4. jjdjdjd dsjdsd\n3. 	ac6099aa-4b5a-44c6-be1b-9f8a8d6a3049	2025-02-05 22:28:41.781235+00
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Hajajhsnnsnna	5b8be576-c60e-4550-a45e-9fc65795f1a0	2025-03-09 11:38:55.990217+00
7aefc064-bbad-40cc-b31e-645c90c9116c	1. Tempe\n2. Gula\n3. Tahu\n\nABC\n	cdf628bd-eaa4-4082-af99-f2dc93b6b6ee	2025-09-12 11:54:18.994618+00
\.


--
-- Data for Name: offline_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.offline_users (id, name, email, phone_number, device_id, device_model) FROM stdin;
f6a3f89b-a424-4fc4-b03b-08deb860c050	wawan	wawan@gmail.com	85664221560	9073ecaf6af66d2a	SM-G990E
6104d08e-c9d0-4d7b-afbc-b234e086f982	muhammad.saiful.engineer@gmail.com	muhammad.saiful.engineer@gmail.com	85664221560	5117b40d95deb1c1	SM-G990E
72db87a2-6d3a-4e0d-906d-cbe489b6e449	Saiful	saiful@gmail.com	85664221560	9073ecaf6af66d2a	SM-G990E
11bdf650-4074-430c-a9c2-65d74788c216	Saiful	saiful@gmail.com	85664221560	9073ecaf6af66d2a	SM-G990E
fdd24e56-1dcc-46b1-915c-7f93b25c4719	Demo User	demo@app.com	08123456789	seed-device	demo-device
9f38182a-26cc-4559-9b50-eb5d2d31b292	Demo User	demo@app.com	08123456789	seed-device	demo-device
b741681a-a2ef-4d5c-bb34-49c09d999437	Demo User	demo@app.com	08123456789	seed-device	demo-device
b655d8cd-6b6c-4b87-8fb1-128ba7b6c368	Demo User	demo@app.com	08123456789	seed-device	demo-device
07cf965a-1b90-43f7-8dc4-b4f5e3d36ee7	Demo User	demo@app.com	08123456789	seed-device	demo-device
396ed1bc-ebd0-40aa-81b1-51138437a5d4	saiful	saiful@yopmail.com	85664221560	9073ecaf6af66d2a	SM-G990E
\.


--
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.password_resets (id, user_id, reset_code, expires_at, used_at, attempt_count, created_at) FROM stdin;
d544b134-1f39-4eec-81a4-3f9b18a92a97	9d659c1f-c68f-4f69-9e21-fbcf37432bab	334344	2026-02-17 08:53:59.917864	2026-02-17 08:44:26.173285	0	2026-02-17 08:43:59.917864
60620c8b-404f-4483-976e-020768d33b78	9d659c1f-c68f-4f69-9e21-fbcf37432bab	435429	2026-02-17 09:13:04.399237	\N	0	2026-02-17 09:03:04.399237
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment (merchant_id, status, invoice_id, id, change_given, total_amount_due, payment_received, created_at, transaction_id, payment_method) FROM stdin;
8765c92d-2303-4374-8c45-6f5ee45d6b48	Lunas	INV-1731724469390	55ff2a94-bdcf-4549-b4ce-c4a650863a50	5000	10000	15000	2024-11-16 02:34:29.476268+00	61bc47e9-74e7-45a7-966e-4992cb88aa5d	\N
8765c92d-2303-4374-8c45-6f5ee45d6b48	Belum Dibayar	INV-1731724545009	5aa165c7-85b1-420a-b807-bf86bac42492	\N	10000	\N	2024-11-16 02:35:45.094935+00	dbf7b75c-f9ab-484a-85d6-3307a2cea958	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Belum Dibayar	INV-1732373588536	ecb11563-1f0a-4406-b3d0-16043cc9ded1	\N	144000	\N	2024-11-23 14:53:08.622415+00	959379d8-779b-4cb0-98b6-a193d5cc63dd	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Belum Dibayar	INV-1732962704477	f1c8f169-4620-4295-914f-e7389c115b40	\N	36000	\N	2024-11-30 10:31:44.557332+00	0335275a-f088-40d6-9c53-bc04dac64b73	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Belum Dibayar	INV-1732962748950	7afe4f03-f3e1-4ee7-a560-770f7795d7e0	\N	60000	\N	2024-11-30 10:32:29.022838+00	c35064f7-b703-46ff-ba31-83c1d05c3297	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Belum Dibayar	INV-1732962769086	52eb12ce-e29f-487e-a5ff-ca7e74127e1a	\N	96000	\N	2024-11-30 10:32:49.158038+00	7374a7a6-d57a-43b9-9d9d-d243e192988e	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Belum Dibayar	INV-1732962789893	87945a0e-0c55-4651-9c96-af8ec255bb15	\N	48000	\N	2024-11-30 10:33:09.965123+00	84bced56-dd6a-41c4-bf20-eb0acda8c02c	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Belum Dibayar	INV-1732963552373	80638948-53bb-4c73-b47e-a73c9529625b	\N	24000	\N	2024-11-30 10:45:52.452386+00	8102f0b1-52f1-41c0-8b49-ee4d50d48479	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Belum Dibayar	INV-30112024.11	65cb2b62-d182-4bc2-b171-d5929f13ccd5	\N	144000	\N	2024-11-30 15:51:26.137123+00	b4eaaca4-616d-440c-9772-fa0924cb30c9	\N
\N	Belum Dibayar	INV-04122024.1	f8915800-d8c3-422a-b53b-65462c29a32c	\N	46	\N	2024-12-04 13:33:39.072098+00	312d588b-a571-485d-81ed-4656dad8781c	\N
\N	Belum Dibayar	INV-04122024.1	ed18768d-bb37-4343-8b44-53d1a7264fde	\N	2766352	\N	2024-12-04 15:33:34.026203+00	c57cc652-1001-4f50-8811-0df436171ba5	\N
\N	Belum Dibayar	INV-07122024.1	01c43a9a-1b3b-4499-9f10-3c2c396d4bf5	\N	3669980	\N	2024-12-07 11:24:07.109296+00	a267603f-3d1f-41b2-8194-1cb9f3c44ec1	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Belum Dibayar	INV-08122024312	ec71fdcd-fdc5-4795-9f52-28b473232f13	\N	24000	\N	2024-12-08 15:34:42.085578+00	b719770b-98bf-4f76-9e6b-253015028922	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-1612202412	2649ddfb-8d72-49fa-92dc-b6b13eafcfc2	\N	99	\N	2024-12-16 15:13:26.049978+00	f9799077-1340-4fdd-946c-8ae85146c0b2	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-1612202413	1d6f28ff-af72-473d-804e-ac83be9d1d2d	3	6	9	2024-12-16 15:15:27.347478+00	24b0a27c-9b5b-4c34-ae9c-695d4a83f874	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-1812202414	30b769d3-9dcc-4a0a-88d6-b266fd5bce78	\N	36	\N	2024-12-18 13:30:46.351162+00	6b2e8f82-e2aa-4598-9d45-c9fca59b661c	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-6110120251	c2206c85-2266-482b-b7ff-04aa7120c733	\N	912819	\N	2025-01-11 15:21:39.391888+00	ee66ec76-e6c8-4cdf-8848-05c8fb1aa692	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-7110120251	163cbf55-7292-4553-9157-e2139bb62476	2531625	912819	3444444	2025-01-11 15:23:32.542227+00	8e03ef80-e134-43ee-847c-4a9b4ba9eae9	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-8120120251	c0e04532-e380-42b2-8f90-20aa8e9b681c	87181	912819	1000000	2025-01-12 02:12:14.447359+00	70daf5e0-58fe-4e89-b2b2-fa9d317cbf51	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-12120120251	39cce18b-1d59-4fa7-823b-f292c5bb872e	\N	12	\N	2025-01-12 02:13:51.922493+00	49ebf261-67de-4783-b7d9-50ca3afad222	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-13120120251	2cb8511c-1dea-4d79-b3a7-27cbb215efd6	\N	912819	\N	2025-01-12 02:14:13.153235+00	eea29823-e752-47a3-b55a-23e02b44aaea	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-14120120251	827d0157-4752-4634-831f-4e080481d547	\N	12	\N	2025-01-12 02:14:29.784089+00	74f0adc8-563a-4022-a572-cda0300fda2a	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-16130120251	70cfcd77-306a-4007-a7b6-61bca0bf9ca2	219	36	255	2025-01-13 14:43:20.129363+00	672ca3b6-7c18-4696-9bd4-74c3de9c7135	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-17130120251	d4cd193f-4926-48dc-9fb6-399b6b29ced3	0	12	12	2025-01-13 14:53:55.875853+00	1faff846-d6f7-4eff-9eaf-0abc7cb5a62d	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Lunas	INV-13251220243	4b320a94-d7bf-409f-a1f6-5bbff8a01499	6000	144000	150000	2024-12-25 01:41:47.132589+00	419b4789-e635-420d-a258-851b7c848aab	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Belum Dibayar	INV-14190120253	75ff89ac-e4be-48d5-b334-156b54f229ee	\N	12000	\N	2025-01-19 01:25:08.368134+00	33cc1efe-55b8-4090-ba49-d4ad00c7467d	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-1212202411	12f6daac-53eb-4150-a104-eb906f1605c8	1388	18612	20000	2024-12-12 22:11:18.738482+00	cfab8dfd-b249-44e4-85ea-44a6df0acc7c	\N
99eea1df-1d39-4fae-a8ca-65e71349b34c	Lunas	INV-1732962730418	90571ee6-7e4b-4aa6-abf5-432ca5a7896d	1000	12000	13000	2024-11-30 10:32:10.49152+00	1e4729ee-3588-418a-86c0-d1ad36a4149a	\N
cc3d67d9-aafd-41b4-93e6-c00b588ec078	Lunas	INV-1250120254	e648af80-10c1-4757-b339-ad978b39a0c2	2532000	468000	3000000	2025-01-25 14:55:34.894776+00	f5f9838b-8165-4575-ab74-bdd6adaaf424	\N
cc3d67d9-aafd-41b4-93e6-c00b588ec078	Lunas	INV-2250120254	3476fd39-6430-4db0-a609-6b1e79d89bbf	0	36000	36000	2025-01-25 14:56:59.48021+00	84853e19-8da0-41d7-bca9-5bc6f3b7db40	\N
cc3d67d9-aafd-41b4-93e6-c00b588ec078	Belum Dibayar	INV-3250120254	87bb7217-0b47-492a-8764-8dcc7e5ace25	\N	36000	\N	2025-01-25 14:58:00.722551+00	26f35f39-c98b-411d-9d78-14d9d9e602e7	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-20280120251	e2491bd6-64b4-4410-bda4-5721c8c58512	\N	459	\N	2025-01-28 09:18:12.714526+00	e7dfeb5c-b143-40a8-924d-1f7763a7a954	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-22280120251	1bac30e7-5528-4bf3-be02-0b07c6cad3b8	\N	12	\N	2025-01-28 09:19:34.361721+00	de84fe2f-90ef-40ee-bcac-f4e7ecefb681	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-23280120251	82d02851-4a41-4275-9505-5c12b89027b3	243	12	255	2025-01-28 09:20:01.105921+00	997079c4-21d9-4e63-b6ff-250a277e129f	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-24280120251	69255f1d-d93c-4e90-89cf-5d0df71acf00	\N	983	\N	2025-01-28 09:20:55.800515+00	0307f14d-0e99-4e68-a3b7-38505600ad98	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-25280120251	88d598d8-b358-4730-b2f2-ee19c3523a12	\N	12	\N	2025-01-28 09:21:37.820688+00	44c0af33-b64b-4038-99ae-51b07338d017	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-26280120251	d2a577a5-8802-4ae1-9437-7b1c7f42bfed	\N	983	\N	2025-01-28 09:21:57.33956+00	d7550252-c266-43f3-92db-6deee5cf2753	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-28280120251	2eb67fa7-7de5-407e-ac28-3c8751b2a982	\N	983	\N	2025-01-28 09:22:59.584277+00	1ca915d5-55b5-45dc-b352-b21ef209bc8e	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-27280120251	039f4f43-3430-40aa-9d9a-acb135f3e9b5	41	459	500	2025-01-28 09:22:20.824275+00	a051d0ab-961d-4ea2-b379-e2f65017c952	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-29280120251	7a872135-a9d2-4e16-942b-76973c5a6836	17	983	1000	2025-01-28 09:23:17.65505+00	9ec61dd0-dc2e-44e6-b1d0-f0c9687e7f9e	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-5090120251	2de7b04a-ad43-44ef-833a-6f93a6eb9cf9	475	125	600	2025-01-09 13:41:42.934013+00	5186bbb5-456b-4a1f-85a0-38e888b736f9	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-9120120251	23b1153d-6178-446b-a2f1-8a389e77e15c	44	34	78	2025-01-12 02:12:46.894251+00	bf68afac-ad56-4a1a-9381-ae5aaaba7ae7	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-10120120251	629d88d2-c98c-4a7e-b82f-ab372af75aaf	66	12	78	2025-01-12 02:13:11.633431+00	8a83eccc-c3ed-4417-bdd7-486131c65246	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-11120120251	d2313e4c-3db1-43c7-82ed-1741c1db7fd9	53	34	87	2025-01-12 02:13:32.0099+00	9d35ee9d-ac3e-46b7-ac1c-826caec34738	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-30280120251	cf58c492-b31d-4038-9c80-2ed7beeb57b8	8017	983	9000	2025-01-28 09:23:44.35041+00	260e6b6f-e5ca-4bbd-a6b8-30229972701f	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-31290120251	59c76d86-ae1d-4987-a28c-1dd828dfedc2	817	983	1800	2025-01-29 00:48:19.184869+00	73131819-ce8c-4aec-a1b8-1e6048753ef4	\N
cc3d67d9-aafd-41b4-93e6-c00b588ec078	Belum Dibayar	INV-4010220254	213864a7-6f43-42c0-acd0-b4d3010b23ed	\N	36000	\N	2025-02-01 16:23:27.915986+00	aeaa59a7-e080-455c-8d80-b0f685d83f66	\N
cc3d67d9-aafd-41b4-93e6-c00b588ec078	Belum Dibayar	INV-5020220254	e6ce4f53-9696-41c6-9af1-6580f2901ec3	\N	36000	\N	2025-02-02 01:55:46.10844+00	c8814cbc-3b30-4bd9-a3d3-d777f8b14f5f	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-15120120251	0baa8a28-e6fc-4f88-ba2b-eea0d3ffe5ef	33	34	67	2025-01-12 02:14:59.731312+00	7fcee3cd-1525-419b-8567-e0c4d3801dfc	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-19190120251	152e441e-2227-46e6-87b2-f16c08feaf71	8076069	912819	8988888	2025-01-19 13:06:58.210974+00	b931fcaa-b3de-43cb-92ec-395e8514db7d	\N
cc3d67d9-aafd-41b4-93e6-c00b588ec078	Belum Dibayar	INV-6080220254	7f327199-96c8-4e8e-a5b8-a5fbca0497c1	\N	1160000	\N	2025-02-08 14:57:59.807135+00	86384141-0cc9-4bcb-bd55-bbe462a19303	\N
cc3d67d9-aafd-41b4-93e6-c00b588ec078	Belum Dibayar	INV-7080220254	e50e13fd-a4f3-41c0-8554-935e22874a1f	\N	36000	\N	2025-02-08 14:58:48.40695+00	843db20a-4a50-4922-a304-c199f317889e	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-32150220251	0f5beb47-228e-490a-82ba-a24249ffb5c4	\N	834	\N	2025-02-15 12:04:50.002496+00	114392f1-af80-459a-91ae-a98dc5769a01	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-33150220251	781f48b8-d82c-4ec3-8016-6eb04aae7856	\N	798	\N	2025-02-15 12:05:37.489376+00	9f80c232-7354-413e-9e6b-bd7da1964931	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-34150220251	0e8ca772-cd6f-4e94-87f4-aae7e357ca72	\N	789	\N	2025-02-15 12:12:05.995365+00	202ccb30-eeca-4125-8588-7cb91fed7d66	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-35150220251	4a621b4d-495a-41d3-bddc-120295bebe3b	\N	36	\N	2025-02-15 12:12:45.188768+00	f00fd946-97cc-4a60-8bb4-95c08b1fbe26	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-36150220251	e59649e8-3449-449c-82bf-d84a9e3a6d74	\N	789	\N	2025-02-15 12:13:22.17836+00	8f51a1ad-cc3d-42c8-843d-7c667673054f	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-37150220251	5d4eeeb4-3fcc-4204-920d-d48133110c6b	\N	825	\N	2025-02-15 12:15:13.812306+00	fdce83c5-2c8d-4038-8238-5dff1ae1385d	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-18140120251	53344a98-c4a5-43d6-adca-80b3ff7e4008	1087181	912819	2000000	2025-01-14 14:35:01.700029+00	3fc34651-bfd5-4575-9e0e-64651283da5b	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-21280120251	67854925-02ff-43ab-9af7-ce135a7b0412	41	459	500	2025-01-28 09:18:52.551273+00	712ce0cd-0ae5-45f2-910f-1b7a0f406966	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-38150220251	cee22ddd-8a65-455a-9430-1277835e465b	20	36	56	2025-02-15 12:15:36.17163+00	90a8a187-6d64-47ee-9a9c-04ca96e10de9	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-39150220251	06d30463-2e46-4d39-9215-6058a240be8c	\N	798	\N	2025-02-15 12:16:23.895937+00	f95ee6a9-e5a1-4d3f-a021-479efc31d7ac	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-40150220251	a075e6fd-b111-455b-b3c2-81a6cd3f330b	\N	4915	\N	2025-02-15 12:21:02.986658+00	b2543dd8-293a-4611-8fc1-d18b90f164c9	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-41150220251	e13a3117-7057-4782-8393-e8dbf5e238ec	\N	24	\N	2025-02-15 12:21:43.494943+00	5cd234fd-3167-4ed7-8476-16621176273a	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-42150220251	8e9f17a3-6166-4a5f-bf5b-fd674cce5d57	\N	12	\N	2025-02-15 12:26:49.508641+00	0bfc5b56-5ea5-464f-ab1f-b68a8449e5dd	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-43150220251	c7c75407-4526-42b5-8560-a03e7a97cdee	\N	789	\N	2025-02-15 12:27:57.258287+00	ea9a9ac7-e03a-4b28-96f9-c9308e094631	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-44150220251	eb0c8989-ae0a-4630-8835-556305497d3c	\N	825	\N	2025-02-15 12:29:01.798322+00	fc931772-cbe4-4073-9afb-542df6c211d0	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-45150220251	bc98afb2-daee-4efc-890f-1ceef1b9ff21	\N	983	\N	2025-02-15 12:30:02.886639+00	eef8a2a7-cca1-4b98-9d44-cab1b92dff4e	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-46150220251	559dfca3-05c1-4a2a-b216-dd6a48b0cf02	\N	983	\N	2025-02-15 12:31:20.133455+00	8f9233d3-0e05-42cb-b942-c4de321d329e	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-47150220251	62dbcef4-2cc9-4285-a99c-2012fdc7e0fd	\N	983	\N	2025-02-15 12:31:53.58977+00	95a82f83-ac49-45f5-962a-3651ce2fe868	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-48150220251	5e97bd6b-6691-4cbc-b26f-28c98ff7abfc	\N	983	\N	2025-02-15 12:32:51.749503+00	de1b6e2a-852d-40ea-ad9b-bdb98e32d3fa	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-51150220251	8f2c373f-c169-486d-b6dd-c3fff0a5ba5d	\N	36	\N	2025-02-15 12:34:54.217799+00	8c8146dc-1ce6-441f-9f70-aabd11cb8a0e	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-52160220251	d71dd625-848d-465b-8aa6-362002d3c822	202	798	1000	2025-02-16 04:34:23.962318+00	c9aac602-46c7-4bd3-a8b0-8a384f1cd96f	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-53160220251	6889cb96-7f7f-47d2-8730-e3bfef4a6f1f	\N	1966	\N	2025-02-16 04:39:07.215929+00	f2102ed4-3f6d-4ebe-90ba-53149eb68bde	\N
cc3d67d9-aafd-41b4-93e6-c00b588ec078	Belum Dibayar	INV-12160220254	fcdaa656-e917-4302-90c9-2c24d18effc4	\N	870000	\N	2025-02-16 15:36:59.525492+00	906a03db-7dcd-46f0-85cb-8917c63df694	\N
cc3d67d9-aafd-41b4-93e6-c00b588ec078	Belum Dibayar	INV-13160220254	c29d8552-1480-493b-a88e-d1bd477095ff	\N	870000	\N	2025-02-16 15:38:18.683559+00	9192f428-27b0-4381-b76c-ff3869459451	\N
cc3d67d9-aafd-41b4-93e6-c00b588ec078	Belum Dibayar	INV-14160220254	96d7c2de-b229-43da-a432-70a5a173b3c8	\N	870000	\N	2025-02-16 15:38:51.125986+00	d4d92003-4644-4da2-9a53-bfc1b940c8a7	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-54170220251	833a92e3-51ba-45c8-86e9-d2c3b35cce36	\N	10000	\N	2025-02-17 07:40:50.144039+00	a066b9b8-6e19-4636-8723-4db4e55e2387	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-55170220251	71905d70-7901-4429-a695-0a27cfe9b670	\N	10000	\N	2025-02-17 13:35:56.26377+00	9307c6c1-d507-44fa-a7f6-f591d6e3cad2	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-56170220251	9d21f608-9edb-4a3d-b664-aa3dacda2c2a	10000	10000	20000	2025-02-17 13:37:27.3454+00	c47e525a-b8a2-4f65-8f84-9cba5b4dea0c	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-57170220251	f5be0b7b-fc8d-4642-8c78-92854ef1e85c	175	825	1000	2025-02-17 13:43:46.611276+00	3ded2ff3-4be6-423a-9244-03c3b4b2d45d	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-58170220251	b1032069-1296-4d4f-8f87-ed91384c94ff	17	983	1000	2025-02-17 13:46:16.93333+00	a81995ed-91cf-4df5-8a01-86f9486a31ae	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-59170220251	6b39d5c7-8959-4eb1-ac50-dae78e9d762d	4	6	10	2025-02-17 13:48:12.154477+00	60eb0b1c-5af0-49e8-863c-fb1e84c2c60e	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Belum Dibayar	INV-60170220251	2b19ebb1-965e-490f-8b5b-0c0b56ff6f20	\N	9	\N	2025-02-17 13:49:21.769913+00	848692cd-014a-4fb3-b8c4-d80e21f50932	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-61170220251	cc43a3f0-cef9-45c7-8e9d-aae1a3c90e3b	55	12	67	2025-02-17 13:51:06.407774+00	fccf31fb-69a2-4077-b8e6-e68767e7cfcd	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-49150220251	52f12b7a-9d69-45c9-bffa-4a0a45bb3ef2	17	983	1000	2025-02-15 12:33:46.231569+00	5ed13606-7ea7-4207-9c60-e06116e41b28	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-50150220251	a8fc421d-2bb4-42bd-8ad3-27d07439b991	1017	983	2000	2025-02-15 12:34:28.931539+00	39a1ba36-61d3-4455-8c8c-de1691af1966	\N
e9bec3fe-766c-41fe-a144-fcb73d705e95	Lunas	INV-62170220251	f59d6ca8-579e-4811-8667-75228e524709	4017	983	5000	2025-02-17 13:51:55.971355+00	12e8aad5-697b-4fa0-9abf-0982d9e44046	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-1070320258	dc1332e6-0b98-41d5-bb4b-f67723839a5b	\N	20000	\N	2025-03-07 12:44:56.156179+00	bb42426b-7211-4e98-9998-6ea316863ccb	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Lunas	INV-2070320258	495c71d4-f920-470b-ba7a-7c1c7e4a9457	2170	47830	50000	2025-03-07 13:06:14.780529+00	96908e2c-9ede-4809-8ceb-4f3a7e9cfce3	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-5070320258	3b95b830-b7e5-42db-ac02-a92770716f4f	\N	8	\N	2025-03-07 13:24:13.21613+00	e30d0340-feff-44b8-bc72-64910b775a3d	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Lunas	INV-4070320258	104857a2-96b1-49d2-83f5-92cbafcfd1d9	1544	1456	3000	2025-03-07 13:23:51.761632+00	7b845bf1-2d2a-4bb1-ac23-46309b57c83b	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Lunas	INV-6070320258	6bedef7b-b068-4110-b7c8-b627a8c4cc31	11	12	23	2025-03-07 13:26:37.060891+00	2c8d806f-2265-4899-a611-6c3e6dbe35f2	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-7090320258	7f1787cb-eab1-4895-a9d0-4173613b711f	\N	12	\N	2025-03-09 04:55:51.398581+00	ef715199-b42d-4c46-bed6-74bfc293d829	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-8090320258	4e17806f-b6da-4e49-bbdb-0793ee0398cd	\N	809	\N	2025-03-09 05:31:32.069587+00	f1673867-965e-4ccb-a32e-dc4d02601656	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Lunas	INV-3070320258	f2f03f8a-2680-4011-a4e7-04143c753048	0	90	90	2025-03-07 13:22:59.479116+00	101e7662-de6c-42a0-a49f-4efe41e05c3b	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-9090320258	dba3df71-6a24-4c76-93e7-fcf3f61460b5	\N	856	\N	2025-03-09 11:37:36.356616+00	cee60a1d-e4dc-4b12-8872-4ae4f09c9c67	\N
361333db-632e-44b4-9192-7f4861046172	Belum Dibayar	INV-1090320256	e3af6dc1-c0c6-4e54-8133-aef3ccb27ba4	\N	69000	\N	2025-03-09 14:35:21.616182+00	6de3e740-4c6e-4c91-8326-0fc9c3f10d7f	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-10150320258	77ed7f8d-7885-4a75-a84f-01f89a7f1d5b	\N	12	\N	2025-03-15 14:02:41.092437+00	d723f378-f151-46ef-8d55-8529d742dc1a	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-11150320258	739ce077-5700-4c1b-8ac7-2d79ee2ae49c	\N	94	\N	2025-03-15 14:07:59.499946+00	440ee46b-f75c-444c-8428-0921c7a85605	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-12150320258	b6461385-446a-469a-8c8c-c6befaebead0	\N	172	\N	2025-03-15 14:27:49.078932+00	55d8ce3a-a2c7-48b8-acbe-a014afb2348f	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-13150320258	aef9518d-2b4e-4c33-9ca2-7fd607aba4c4	\N	81	\N	2025-03-15 14:29:59.583696+00	b8343ec5-0176-477d-adfb-89bc39054e38	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-14150320258	1e9010ca-a95c-49d3-9942-5afd3713992f	\N	163	\N	2025-03-15 14:30:45.309705+00	efdf4c6e-294c-4f30-a987-963c98395e67	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-15150320258	b78bbea6-2985-4de8-a13b-edcf0daa58b4	\N	89	\N	2025-03-15 14:35:27.039771+00	28b63c8c-7acf-4a5b-b1dc-642f095339d0	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-16160320258	e44191c5-a980-48aa-8bc4-c4be0dbbb273	\N	9238	\N	2025-03-16 03:27:07.494225+00	3f274617-d6e0-4a66-ac9b-7f640a5158b1	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-17160320258	a4e7ef91-78ee-4615-b675-a69ab0a5f500	\N	8	\N	2025-03-16 03:41:13.759599+00	712f536d-a13d-4e5d-9357-f0b1a2c81aad	\N
ca3cb819-ec42-4b13-883e-e3131abe9bb2	Belum Dibayar	INV-18160320258	d43f2cad-1cd1-4a3a-9f98-457349958585	\N	81	\N	2025-03-16 05:32:55.664428+00	01bb1c66-dd3f-4c8b-9fa2-d9403361b59b	\N
85239af0-2860-4e35-9f6f-5aa79a10ceb7	Belum Dibayar	INV-11603202511	25649e41-9009-4e8d-ac0a-6a172d839eee	\N	16000	\N	2025-03-16 06:34:08.064225+00	aa550e92-49f2-4abe-b89c-1f5bbca65738	\N
e231be7c-213e-4500-b437-e7ed94f468a7	Belum Dibayar	INV-12003202517	0486a7da-0985-43c4-a4b1-3fbffbc5d3a3	\N	24000	\N	2025-03-19 23:37:02.582304+00	573f576c-92ec-43c8-b4ae-d9ebc30babfb	\N
8ea1e721-d977-412f-86fb-17585368a773	Belum Dibayar	INV-13003202519	77a178c0-46a6-4376-af6a-318439aca007	\N	30000	\N	2025-03-30 07:40:25.399319+00	2567f1aa-8509-4380-b7fb-ca55c7d4b8da	\N
361333db-632e-44b4-9192-7f4861046172	Belum Dibayar	INV-2300320256	9ae4638b-121d-4de2-83e9-8ae5f74b0c9d	\N	23000	\N	2025-03-30 07:40:33.19247+00	f66b72df-3566-40d1-8c30-170aae89dc8a	\N
8ea1e721-d977-412f-86fb-17585368a773	Lunas	INV-20204202519	633fde70-55c9-4462-9977-f67806014756	216555	39000	255555	2025-04-02 14:26:35.700933+00	036dc231-bcd0-4bb4-acf6-40272cd812ba	\N
e32ad1af-905e-4781-86ae-389edd96ff9d	Belum Dibayar	INV-11404202523	8f02721c-2d67-444f-8322-b9af6d02592d	\N	25000	\N	2025-04-13 23:52:09.464818+00	ccc44ed8-1f95-4485-a397-5d8d17c36f06	\N
490e65e1-0159-4a63-855c-b3ed8e621ef4	Lunas	INV-12105202534	e8125bd6-c250-4d39-9c69-04673e46475f	6000	104000	110000	2025-05-21 03:14:03.850508+00	650bc176-0afd-4356-bdca-4fb57450c950	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-13105202535	930fb19d-da9c-4982-8d1b-83a5c00d5285	561000	39000	600000	2025-05-31 03:03:11.268462+00	41793b8a-4fdc-47fb-8813-b046c6374ebe	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-21506202535	4df961e9-f1de-47ec-ac6b-2ec0fdd9ff04	\N	4000	\N	2025-06-14 22:57:48.468704+00	4a5b97f9-d976-4d77-a514-c97aaffce92f	\N
9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Belum Dibayar	INV-11808202562	0b457217-29a5-4477-ad03-4960a8fe2ce2	\N	8000	\N	2025-08-18 07:17:01.54276+00	2b57ca63-6ecc-4d36-bf83-c0e98aff8bc5	\N
9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Belum Dibayar	INV-21808202562	cd973d27-32f5-46d7-b94d-40711ea00f60	\N	24000	\N	2025-08-18 08:47:55.119953+00	acb93871-4cf7-4b06-80df-69570955efc2	\N
9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Belum Dibayar	INV-31808202562	a593c862-8538-4cbd-8f99-c75697301185	\N	50000	\N	2025-08-18 08:48:16.518741+00	891e2801-3321-4141-83b6-7ebd8315aca6	\N
9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Belum Dibayar	INV-41808202562	e584f2d5-bbe0-4ae8-9df7-04468da67404	\N	26000	\N	2025-08-18 11:34:05.187366+00	2aa00967-9909-4471-8026-445f94d6b166	\N
9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Belum Dibayar	INV-51808202562	094832b9-b9f0-4e4a-aef5-3951bc6bc03f	\N	45000	\N	2025-08-18 11:34:35.411839+00	73b230d6-4a56-4351-9119-1f9b2be38f00	\N
9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Belum Dibayar	INV-61808202562	34ba41f6-8898-4b65-bd02-5a8224bf4276	\N	20000	\N	2025-08-18 11:35:29.866796+00	84501ebd-7524-4dfd-8980-99707307097a	\N
9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Belum Dibayar	INV-71808202562	64e27ec2-21c1-4cdb-9e1a-1212ee145795	\N	40000	\N	2025-08-18 11:35:51.230125+00	400b7683-35bb-4fe9-b63c-2b04842a2c6c	\N
fe4e3388-40d9-422a-8140-a5a21ab56fbb	Belum Dibayar	INV-10109202563	795002ba-b36d-4998-809c-670176a9bd8b	\N	5000	\N	2025-09-01 11:02:08.484264+00	ab4aaf67-7f76-46d4-b008-7624eec84f1c	\N
fe4e3388-40d9-422a-8140-a5a21ab56fbb	Belum Dibayar	INV-20109202563	addb43eb-0890-4d5e-86ab-0771fe546353	\N	28000	\N	2025-09-01 11:18:43.887268+00	7068bad8-8a18-49f0-b656-64d048e44487	\N
fe4e3388-40d9-422a-8140-a5a21ab56fbb	Belum Dibayar	INV-30109202563	d0f4eac2-cad4-4001-a2cb-122963e42324	\N	25000	\N	2025-09-01 11:20:24.28952+00	70f208f0-a332-4902-9f6f-9c2523a19fe3	\N
fe4e3388-40d9-422a-8140-a5a21ab56fbb	Belum Dibayar	INV-40209202563	4c97b30a-9f77-422b-87ad-60ca7a1bc2d4	\N	30000	\N	2025-09-02 13:30:58.299514+00	f58fc281-e0d8-4555-a977-3f0d0889529e	\N
7aefc064-bbad-40cc-b31e-645c90c9116c	Belum Dibayar	INV-11209202564	2a7704e4-862a-46a0-b2f7-0f2c679465d7	\N	5000	\N	2025-09-12 13:25:42.183982+00	1827f84f-c82a-4eb3-ac33-3f77847bcc4a	\N
7aefc064-bbad-40cc-b31e-645c90c9116c	Belum Dibayar	INV-21209202564	96f3be10-99bb-44e9-ba34-9a3a007d3d64	\N	10000	\N	2025-09-12 13:26:47.116978+00	550c06be-c03f-4062-907e-778836a66628	\N
7aefc064-bbad-40cc-b31e-645c90c9116c	Belum Dibayar	INV-31209202564	1c370702-5ae9-4bf4-b3c3-8805ea7aed74	\N	27000	\N	2025-09-12 13:27:32.487118+00	b4cf2e88-7d8b-4c00-85a2-2bf59d05bc2e	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-12309202566	4cb3503f-7fda-408b-9967-be1dfd1c4d5c	\N	22000	\N	2025-09-23 12:07:08.598454+00	d4c3027a-a21d-4dd7-888a-e2e59fc1268f	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-23009202566	e219a021-49c5-493f-8517-7d18b6f0fc36	21000	179000	200000	2025-09-30 14:18:29.218446+00	134b683a-9bf9-4e85-8b69-ddb95baeba5d	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-30110202566	525a4d1e-e9c0-4b43-98e0-a9af245b4b14	\N	54000	\N	2025-10-01 12:59:23.018527+00	b9198f73-5ff7-494a-88f1-ff4c19d2349f	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-40510202566	d59c0060-ec55-49e7-ae40-5d82100ae34c	\N	6000	\N	2025-10-05 13:56:39.175299+00	e6f8a3cb-9bf5-474a-bcf1-3bee86c8ea53	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-20810202566	eb5eeb83-f7b6-48e4-951b-0135153f2def	\N	72000	\N	2025-10-08 14:31:16.125444+00	abe7f733-2215-44db-b96f-88ad828c6bc2	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-30810202566	663c3d85-6352-464d-bcf1-1fd176cd6f89	\N	72000	\N	2025-10-08 14:32:28.111942+00	741bee5d-340c-4084-971c-ce57c1d10650	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-11010202566	4b1e17df-ede2-4261-af3e-c772576a78f9	\N	72000	\N	2025-10-10 13:13:29.414448+00	e217fe0b-36c3-4264-a1c5-d2d2697891cd	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-21010202566	10f3ffb5-32f3-49b9-8434-f2a34c638cdc	\N	72000	\N	2025-10-10 13:21:53.76242+00	f4d3a0ab-1f3e-425f-96fd-e4cc6217950f	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-41710202566	493a2ed2-c81d-4f68-ab31-a5a27c538fdd	\N	48000	\N	2025-10-17 13:28:30.21294+00	ffd03e9e-c787-40ad-afa1-4dd490b40e80	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-51710202566	fd52d599-2241-49ec-b454-4fcad0bdac9c	\N	34000	\N	2025-10-17 13:31:39.311342+00	8a3b8432-8441-4e57-bef4-89be1dd0f578	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-81710202566	585f9457-44d1-4782-93b0-08566044c01d	\N	34000	\N	2025-10-17 13:36:33.602348+00	2ca8ad49-b3b9-4a01-8285-9883f34df992	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-111710202566	c0499a44-ac44-41ef-ba62-a25ecb87ecbd	\N	34000	\N	2025-10-17 13:39:58.811573+00	5dde48c9-9352-4213-a5f2-e7e059fc435d	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-121710202566	a478faaf-00bd-4a02-8df5-99c7f19c5e8e	\N	34000	\N	2025-10-17 13:40:35.704308+00	c79e4d4d-366f-45ef-8e80-f6c8683ac8ea	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-131710202566	7ce7d248-d312-4cda-baf2-e4f42ff4bca6	\N	34000	\N	2025-10-17 13:42:26.900147+00	e6a8eb85-1539-483d-9c79-cdf95b4f36af	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-141710202566	87ffbab4-ad0d-4b08-b01f-81d4eafb579d	\N	34000	\N	2025-10-17 13:42:58.988072+00	8ac553fc-d111-487d-96bf-c14e2447d128	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-151710202566	4d5dbaf1-ffdc-48bb-a93b-bf30ef0cc881	\N	34000	\N	2025-10-17 13:43:27.190137+00	5f6b6df0-53ef-4ac2-ba36-ee36dee6e901	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-161710202566	42e353df-8fd6-4cfa-925e-4e5358bec3d1	\N	68000	\N	2025-10-17 13:52:30.868499+00	f522e287-fb13-41a2-8bbf-63d76ffbc006	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-171710202566	81d6245a-c427-4df1-9efd-fb4c2d6d8621	\N	68000	\N	2025-10-17 13:55:57.232144+00	6083db98-a0de-4f5f-aed0-48bc034fb8f8	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-181710202566	85ad18a4-1f70-4985-a7b1-7855ee00f559	\N	26000	\N	2025-10-17 13:58:54.139412+00	11d0a36c-a55b-42a2-a523-8da140667f5a	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-191810202566	1ea55cba-36de-4b55-850b-eeb6f9b6819a	\N	26000	\N	2025-10-17 21:31:37.880221+00	3b246b84-8bd2-4fa5-9f31-d77eeec50808	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-201810202566	045a17bd-0376-436e-85b0-f8e1b0a033d9	\N	10000	\N	2025-10-17 21:36:58.800451+00	54d871be-87d5-4675-acf1-c67e1b7387a5	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-211810202566	ccac93e9-6f99-472c-92d1-dbbe76c97317	\N	26000	\N	2025-10-17 21:39:15.923126+00	1fa2c82b-eaad-4ffc-b7e6-3fac0b751deb	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-221810202566	5cb53904-f5bf-42b4-9745-7e7efc366c45	\N	18000	\N	2025-10-17 21:45:49.609246+00	42d05911-6b42-4bfc-85c1-85cf3c1e6161	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-61710202566	db2c860b-a8fe-4a25-9463-8b480dc29b30	6000	34000	40000	2025-10-17 13:35:19.489581+00	90b7cb1b-c809-4372-9c5c-ddca831b7a51	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-71710202566	32a4ffc5-d427-420f-b971-d81c501456a1	16000	34000	50000	2025-10-17 13:36:04.387712+00	75d8ba9c-1ad5-4970-afd4-e001cfddd1b0	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-241910202566	efa29258-7e13-451c-8bbc-f0618f825a1e	18000	20000	38000	2025-10-18 22:24:24.545264+00	c21b4e83-45e8-4ce9-8ff9-1abc78b5dd20	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-251910202566	2bfef7e3-aa37-4acd-8192-b8fc2a67b3ee	30000	30000	60000	2025-10-19 12:32:41.528553+00	30575655-aa99-482f-be0b-637da76e3e62	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-311111202566	c036413a-6b71-4baf-b4d2-38aeb6f412a8	\N	10000	\N	2025-11-10 21:00:39.664418+00	895b8296-c5e9-4f5d-9413-671e1a20d148	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-231810202566	7b7a0dc6-1f3d-431b-a864-c679734291d0	0	20000	20000	2025-10-17 21:50:26.90555+00	d64225d9-4684-4f07-9f6e-1f4dfacdfb07	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-31110202566	14d8886a-31d5-4b28-afae-f9ca83dbe825	332000	168000	500000	2025-10-11 08:26:38.828191+00	e09d4a5e-a4cc-44de-b20f-844ca4766821	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-262210202566	0b96ffaf-d31b-4e7e-a93b-df49e104dd93	\N	14000	\N	2025-10-22 09:55:34.176978+00	d27fa641-3a9b-4961-bdd3-910828bcee9b	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-272410202566	3560dedd-9283-411a-b6e4-d795cfc74bbe	\N	14000	\N	2025-10-24 12:19:53.3087+00	4005c685-15cc-45b9-aa17-8b5a85e6cdbb	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-282410202566	bf45d512-d0f9-4354-a6b4-dbba3230e8ad	\N	28000	\N	2025-10-24 12:23:38.648417+00	1f00b27c-f270-4716-a891-4c7e701eb85e	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-321111202566	6e47c7ce-7e8f-425c-843b-c4b9fad78b32	\N	4000	\N	2025-11-10 21:18:36.345583+00	94b6fa54-712c-4784-8e37-801ca06e52f6	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-331111202566	973aa614-3c15-417e-8ad7-085b9de35cb2	\N	20000	\N	2025-11-10 21:33:19.672338+00	02c67a86-cdbe-442b-95ce-9cf76a8e7d84	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-91710202566	be34aa96-36b7-47ce-8075-ac8998821ea0	16000	34000	50000	2025-10-17 13:37:19.57086+00	1b12893c-f23d-4c62-9f47-f498904fb0db	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-290211202566	771e132d-c204-4a5a-9ec9-37d6399c1bcc	\N	6000	\N	2025-11-02 13:40:43.553147+00	a57ef7a3-d324-4155-ac55-e8264e3c0b1b	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-300611202566	b40c605c-3966-4462-8cac-7c74b53ee2ea	\N	18000	\N	2025-11-06 13:02:20.252997+00	5ddf3c56-7fd6-4c70-8c4f-dd15409c1f51	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-341911202566	c53c59b9-3238-47bb-8dc0-598f428066f3	\N	20000	\N	2025-11-18 23:04:50.821471+00	bf148b64-9708-4f2d-9469-cdf802cf31dc	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-351911202566	25c2ed2f-d631-4b3e-b55f-7a237e02970b	\N	25000	\N	2025-11-19 13:51:22.801894+00	e7e0704d-6559-46a0-a70d-cc63d3cc5e93	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-360612202566	e3b176be-74a5-4706-9994-daa3c8e193fe	\N	59	\N	2025-12-05 22:46:27.793305+00	7b22880c-8fd2-485c-a04f-f70d1ca77216	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-370812202566	d9d12040-07f1-4565-b90c-73c7667d5310	3	95	98	2025-12-08 12:18:18.913159+00	def56394-968d-4d95-8038-66e511f89e90	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-101710202566	7fed4ff2-21a3-49c0-95db-b187b5ed1cfb	16000	34000	50000	2025-10-17 13:39:19.885686+00	9afc00ea-4b0b-4c69-a2c2-1c970401fef9	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-411412202566	997870d8-f03e-4c3f-a0da-2498ae6d5f42	\N	168000	\N	2025-12-14 01:22:42.469799+00	95e3bcfe-889d-4545-8c92-3d2da9f35a82	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-431612202566	25badbdf-3751-443f-9faa-9143db11277b	54355	1200	55555	2025-12-15 22:37:31.376864+00	0f6fa71f-e56c-4342-a6e5-3fa0f95d5b29	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-390812202566	bd25307c-f8cd-4825-b551-fb15ea958dba	440563	115003	555566	2025-12-08 12:30:31.518926+00	28601a0f-8ce3-466d-85b5-d6d7d45902b2	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-441712202566	a0e032ef-e245-4478-bbec-9e68f41edc4a	530555	25000	555555	2025-12-17 12:21:15.754267+00	50944c9b-4c7b-4925-b59a-7fd557b33788	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-380812202566	562d0c73-d4e8-4226-8f44-dd6992e1d272	18981	1019	20000	2025-12-08 12:29:26.288138+00	05e2483b-2aca-4238-ae92-e64fbd05479e	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-401012202566	f47f9764-6daa-4031-8e4b-48a4b7d21a56	334	1666	2000	2025-12-10 13:07:40.625914+00	bb5ba42a-aad8-465e-a260-ab09e41a602f	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Lunas	INV-421612202566	a0e2151c-9e96-4722-97be-6b3a2b94b044	30000	70000	100000	2025-12-15 22:18:07.559761+00	7b8f664f-ac53-4059-9bbe-97af430811fc	\N
8db3f967-5f09-4150-a95b-010faa31a22a	Belum Dibayar	INV-452612202566	44f5381f-d7e9-4283-89d5-b11aabc2c30b	\N	56200	\N	2025-12-26 12:36:10.478563+00	cb621eae-5ca0-4b27-94c7-896d5b68eae8	\N
20a1b60b-2c45-4533-a02e-ad9d4545b860	Belum Dibayar	INV-12612202575	cf0ad099-f597-4bf5-9ac6-ef3a3b765915	\N	6000	\N	2025-12-26 15:08:36.791461+00	18d77d67-991f-4a13-a28b-64e396c7d559	\N
20a1b60b-2c45-4533-a02e-ad9d4545b860	Belum Dibayar	INV-22612202575	5c5a22b6-93f7-4a0d-bded-498c20dc955a	\N	6000	\N	2025-12-26 15:14:31.576378+00	53f4fe58-6e38-43a5-8005-ae82cb69661c	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-12102202635	c16b2337-d09e-4cdc-859b-dfb8f8d61952	\N	422000	\N	2026-02-21 07:37:58.909547+00	c948b7be-c928-4d41-a30e-9fee97fc3429	\N
65e7caf4-1316-49da-a3b9-3b7f8fef3955	Lunas	INV-12102202686	1ef43065-eb5b-4ff3-aa9c-c6b4cd7a29ab	0	36000	36000	2026-02-21 07:42:34.250309+00	412a9ed7-a746-422d-9bfc-98d35070bd69	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-22102202635	f4558c71-4311-4eba-ad8f-4d0f01366527	\N	20000	\N	2026-02-21 15:09:59.571346+00	905a7ec2-c47d-4797-9355-d13e7138927d	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-32102202635	3e2d0cc2-0db6-4484-9686-76545c28a2ea	0	19200	19200	2026-02-21 15:17:43.327708+00	41971f36-3855-401f-a6d1-3c1511de668e	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-42102202635	32bfe25d-4f12-4540-872a-337026b7cda2	\N	7200	\N	2026-02-21 16:07:42.570308+00	7b9968a6-94c7-4010-b208-3cfc7ed21ef9	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-52102202635	731cf776-6cb1-407e-9458-2091fc9e0597	\N	216000	\N	2026-02-21 16:14:27.596688+00	224661bb-7af0-4c87-a9af-a3d18d785267	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-62102202635	e24e4b4f-a266-4ca6-a190-d7eca612bdad	\N	36000	\N	2026-02-21 16:16:01.005815+00	ebc9fecd-413a-4696-98d1-bd7d853c0a80	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-72102202635	e7e1ee07-5e09-4dd9-af8e-f9a7cc212aba	\N	12000	\N	2026-02-21 16:20:00.372791+00	50a64cb9-6f17-4de2-ab28-8dcf626a0bec	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-82102202635	f4e25750-f132-4e35-97be-228c4c7d623c	\N	12000	\N	2026-02-21 16:21:52.563369+00	a0e0fca8-900e-431f-bd01-13c2eb740c59	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-92102202635	fdafdae3-65ff-4952-b9d0-a5fbe1cb104f	\N	17760	\N	2026-02-21 16:31:14.528941+00	f29aaf5d-2d01-4f7f-a8ec-5ad27247f890	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-102102202635	2e69a4bf-e1dc-4f98-afa0-335797493f2a	\N	12000	\N	2026-02-21 16:32:08.434601+00	5431b440-fcc1-4120-bf0a-d318743e5287	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-112102202635	dd83dfa6-4305-4fcf-b65d-d672b153ce5a	\N	12000	\N	2026-02-21 16:33:06.89447+00	70788efd-9d84-46d9-8218-93f7f05392ad	\N
cf7cfef7-6850-46c2-9efc-22c28cb0922c	Belum Dibayar	INV-12202202687	b619c101-e678-4338-be35-3c8330b41095	\N	26000	\N	2026-02-22 13:42:12.092751+00	f8813a16-41c0-4f2a-9911-09c3ba012113	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-142502202635	db96833f-1dcd-4279-a61d-91973b2d769a	\N	168000	\N	2026-02-24 23:20:20.684093+00	e34ed06f-91e3-4f59-8252-77e468a02616	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-152502202635	7c364f68-abd4-434f-9370-915838edeb77	0	168000	168000	2026-02-24 23:23:50.647161+00	67839993-8703-4488-a107-cc68c62b7f4e	\N
4b843f69-8041-4846-8af4-872de4c5c41e	Belum Dibayar	INV-12802202688	cda4f84e-3c3d-4db1-9d77-cd79dcf83ca8	\N	14000	\N	2026-02-27 23:52:13.46504+00	a9b9f077-c256-4c99-86a9-e0c376b5f496	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-122402202635	e93e59f5-4583-4e1d-9bef-7ef5e853da76	2000	28000	30000	2026-02-24 13:29:02.825697+00	2ab4050c-1530-4f34-a012-e28b492c58d2	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-132402202635	7c686d39-5714-4a74-8384-7ff87166dc40	0	16000	16000	2026-02-24 13:30:44.617856+00	88e270fa-841b-41b8-83f6-d5b7d03af423	Tunai
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-191003202635	008e526a-3949-4837-b426-b5b0b47f1b99	\N	13964	\N	2026-03-10 13:13:20.291122+00	19faa009-c44e-406e-a944-31b09c8f4d9a	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-201003202635	8d677a24-8380-4c11-80e9-55148b112549	\N	7000	\N	2026-03-10 13:26:36.108745+00	69f5d6f0-f634-4ee5-b89c-27035c44ad3a	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-211003202635	d69fa61d-79b9-4113-ae38-81f6b821dee3	\N	35964	\N	2026-03-10 13:44:59.895342+00	ce77ff93-c08b-4b47-b52c-46dc875d1d83	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-162502202635	4d37e7cf-faf1-493a-9ee7-d57a3510e8d9	0	39600	39600	2026-02-25 10:32:08.765821+00	1b1e49e7-5f90-4b59-aea7-3bae79617f46	Non Tunai
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-231103202635	2b4daa6e-b25e-4fc3-9b3e-75c83d564557	\N	12320	\N	2026-03-10 23:06:49.255347+00	ec6d86a0-8605-4401-b820-51d9b474a264	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-221103202635	e2a02111-019a-4388-bc22-829374de7db8	0	26400	26400	2026-03-10 23:04:44.884037+00	b2a26589-e8b7-4b95-9621-52743d5660b5	Non Tunai
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-170903202635	1bd31a2a-b552-4291-aed1-d8850f78b38b	10000	70000	80000	2026-03-09 16:51:27.517711+00	7276fb30-d2eb-4d68-8b5d-c21434ff1f5a	Tunai
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-181003202635	c42d411a-9d50-40f1-978e-e123fa1f1dbc	0	6000	6000	2026-03-10 13:12:45.540136+00	bfa5d795-5866-4fe2-9cb2-81e83acf7b38	Non Tunai
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV.35.0024	6396d103-6b95-4be6-ad8f-8246239522e1	\N	72000	\N	2026-03-11 17:39:17.923126+00	d4e5158d-4190-4a50-b087-7cec89d76659	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-35.0025	f4beed84-bc8d-4cae-89af-88dd4b6d3f48	\N	72000	\N	2026-03-11 17:39:58.24236+00	4137dfaa-4c90-41c9-a14b-5c503ade6c68	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-35.0026	d2b97fa0-c6dd-4929-ad77-2fc83510b46b	\N	72000	\N	2026-03-11 18:00:45.311614+00	b38a3f30-f978-4001-bfc0-1c59b4b4bae9	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Belum Dibayar	INV-35.0027	1efcbc94-39a9-411d-a604-661c96b07e2b	\N	59840	\N	2026-03-12 00:52:15.089542+00	6e56c1b3-0e7e-4494-ae71-153f316b8f4f	\N
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-35.0028	6b2e8f58-3606-4b3b-bc5b-2c0f8b069f51	0	55000	55000	2026-03-12 02:02:18.077957+00	e6a66e22-181f-478d-898a-15781e6e13ba	Non Tunai
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-35.0029	e67d43e4-0b95-48e2-bbab-c891af1b3006	500	9500	10000	2026-03-12 02:19:32.062381+00	c2371b6b-b04e-4f3b-b4de-07b061659d81	Tunai
9d659c1f-c68f-4f69-9e21-fbcf37432bab	Lunas	INV-35.0030	352f13d2-ed16-4e54-81ef-3e414b0c76b9	0	72000	72000	2026-03-15 21:37:25.173512+00	2c0e2d7d-8bbb-4c45-ba27-878e05efb65a	Tunai
\.


--
-- Data for Name: printed_devices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.printed_devices (id, user_id, device_name, alias_name, device_id, is_active, last_connected_at) FROM stdin;
785a5253-3844-496e-b98e-050e2259ec48	8db3f967-5f09-4150-a95b-010faa31a22a	RPP02N	RPP02N	86:67:7A:33:89:13	f	2025-12-23 13:58:56.877297
ecea2463-fcb4-4745-8020-35bb14063228	8db3f967-5f09-4150-a95b-010faa31a22a	Printer A	Printer B	123213	t	2025-12-23 14:01:32.714278
f0641469-f1bc-4118-968e-95e449b35f1d	6fed4540-3689-4ee4-837d-614174568f7d	RPP02N	RPP02N	86:67:7A:EF:8B:0C	f	2025-11-18 12:48:22.547565
75d9f6ed-9d33-4016-aa5c-107578726d2e	6fed4540-3689-4ee4-837d-614174568f7d	RPP02N	Yoloooo	86:67:7A:33:89:13	f	2025-11-18 12:53:42.811034
72815342-1c3f-428d-ba90-0439f7e7bc02	9d659c1f-c68f-4f69-9e21-fbcf37432bab	RPP02N	RPP02N	86:67:7A:33:89:13	t	2026-03-12 00:54:33.918588
\.


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.service (id, unit, created_at, merchant_id, name) FROM stdin;
53690299-8319-451b-b341-c8fe6f907052	KG	2024-11-11 13:38:47.310799+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
1b9f8954-a53f-4b9d-8e4e-5dcdc6f774c9	KG	2024-11-11 13:38:48.712672+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
36df7c6e-62fc-4fd0-899f-df6d055000ef	KG	2024-11-11 13:38:49.794407+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
8ae334d7-f77f-4eff-8ebb-aa27efb0a6ac	KG	2024-11-11 13:39:06.784094+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
f0b42481-499d-4425-8917-af7538643455	KG	2024-11-11 13:39:08.300448+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
b702a4a0-06e3-4f70-9586-faca4c21b18e	KG	2024-11-11 13:39:08.329043+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
1e183082-ed17-49d6-a577-aed879b11b42	KG	2024-11-11 13:39:26.251467+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
c5e4beb5-b49a-4b92-88a5-3ae2258dab84	KG	2024-11-11 13:39:27.396128+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
f203f297-852b-453d-8276-6665abb8ff2a	KG	2024-11-11 13:39:27.503131+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
0b1fe87d-9114-413f-aed1-7d452e50af03	KG	2024-11-11 13:39:46.968652+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
10bcb992-1762-47ba-878a-648f7cf4b732	KG	2024-11-11 13:39:47.166724+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
4887d5b3-4beb-43d6-ab15-a447b9655b5d	KG	2024-11-11 13:40:08.083289+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
5538a2f9-67ea-4e22-9b36-872247e6d20b	KG	2024-11-11 13:40:34.373549+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
8493e97e-a574-4f93-a88a-ca2f7a6f617f	KG	2024-11-11 13:40:36.242081+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
458126fc-4a90-4540-893c-b281c06f4325	KG	2024-11-11 13:40:40.315374+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
ff267bd5-99a9-4b90-ad69-fe701f2adf81	KG	2024-11-11 13:40:45.506688+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
e041cc17-bdbb-4d6b-85fd-5afa2d3cd51c	KG	2024-11-11 13:40:48.239089+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
7826f0b4-b1e3-465b-bb03-fc1e174299b4	KG	2024-11-11 13:40:56.374181+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
94305336-ae4e-44f0-92f1-602fbf48e764	KG	2024-11-11 13:40:59.203259+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
5f3971a3-8d2f-4f9a-bfa3-15d59adffaf4	KG	2024-11-11 13:41:05.319488+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
522f4f75-4e5b-42ea-9b3f-746ba43eec47	KG	2024-11-11 13:41:05.662147+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
4a0cc414-588a-4aa2-bf1a-e64d2361cd9f	KG	2024-11-11 13:41:06.657744+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
aa613fa0-5525-462e-beba-cbb29b6ef26b	KG	2024-11-11 13:41:24.938224+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
06e9cc26-ba82-4bdb-9664-ce1c6221b322	KG	2024-11-11 13:41:48.817554+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
b4981875-fc9a-45e8-9f41-b794197831ee	KG	2024-11-11 13:41:53.480292+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
b0549c28-69ee-4fe6-ace8-c8123d6b8411	KG	2024-11-11 13:41:54.567859+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
17b12d16-8e0f-4269-bc73-b0e335767788	KG	2024-11-11 13:42:03.958407+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
43b82559-147d-4703-8e4c-53636f40817d	KG	2024-11-11 13:42:09.51564+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
3f936b70-3f91-4442-ad39-4748f8541807	KG	2024-11-11 13:42:09.93347+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
1daed629-00c7-4f8d-b20c-723130cb3b45	KG	2024-11-11 13:42:13.364517+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
72103d77-0197-4dd3-a45a-1336c46253f7	KG	2024-11-11 13:42:14.631451+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
2ef3eccd-f1e0-4d48-be8d-e4145eaf4dca	KG	2024-11-11 13:42:18.24019+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
1e01d0bd-85ac-423f-8a8c-3e8c27450837	KG	2024-11-11 13:42:20.424664+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
a67f9255-92b5-4782-afdf-5d96137021c3	KG	2024-11-11 13:42:32.931825+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
5fc0b116-89d6-4cf8-b516-c063c3f841ed	KG	2024-11-11 13:42:34.162346+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
6a3ab264-50b2-4b58-8b77-ab2acbc51b9a	KG	2024-11-11 13:42:38.334446+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
1e89b888-2366-4981-8b1d-ac34373fc48a	KG	2024-11-11 13:42:43.462914+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
ae717658-9898-45da-b79b-76408108b220	KG	2024-11-11 13:42:52.401533+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
f6b7c4c4-38c6-47d3-877e-7dfdc327be85	KG	2024-11-11 13:42:53.620982+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
5af59d23-d481-4e46-ba02-dc4b6a749f0b	KG	2024-11-11 13:43:07.118905+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
85775326-947d-482b-865c-76e131a93203	KG	2024-11-11 13:43:13.595463+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
10093706-abcb-4b8c-bf02-4134000b5755	KG	2024-11-11 13:43:17.528276+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
16b6b107-5883-42ed-907e-854076ec15be	KG	2024-11-11 13:43:24.012804+00	568d9a9d-2a4b-4f0a-baa1-9ae24842f0aa	Laundry Jos
0cef9b3e-1552-4c21-b0ae-9267423592d1	KG	2024-11-16 02:34:05.002679+00	8765c92d-2303-4374-8c45-6f5ee45d6b48	Laundry Express
70db1bf9-e2b5-4947-868f-a1f61afe185e	KG	2024-12-15 09:25:12.783182+00	8ae5aae4-201d-4be3-838d-70c5de9e1a0c	uhuy
c6115e3c-1cec-4d66-8633-afa8edc58f89	Woke	2025-01-25 14:49:45.376806+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	1 Hari Jadi
5c76318d-2be6-445a-bdb1-e5ae05ae32be	Kg	2025-01-25 14:50:40.173585+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	Cepat
7676c149-9f68-4106-a4a6-7cca645d04d8	iq	2025-03-07 13:05:06.896884+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	oask
62f8f9c0-c04d-4d09-9e06-8a0358e2f744	KG	2024-11-23 14:52:44.431308+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	Laundry Jos
bb807b3e-fef1-4c39-b3ed-1118a69b3a78	123	2025-01-19 01:18:32.092885+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	ok
2c021478-4326-447b-b52c-8fd617861779	9ds	2025-03-07 13:04:51.353485+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	Kkkkk111
6815b87c-940d-4ddb-8f4b-ec571fce4aac	dsk	2024-12-15 09:51:34.672251+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	dsdkd900
19cfbd67-2029-4a63-88f9-b3a0efcb9fe5	KG	2025-03-09 14:35:09.91787+00	361333db-632e-44b4-9192-7f4861046172	Kiloan
628bff68-94f5-4175-b05f-87efd6b0a74c	12	2025-01-19 02:53:27.57814+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	test123
bde7789f-c453-4370-ab87-76f2f600370a	KG	2025-03-16 06:08:49.695675+00	85239af0-2860-4e35-9f6f-5aa79a10ceb7	Kiloan - Cuci, Setrika
6d35a211-8b56-4394-af11-b4152f0f216c	12	2025-01-19 02:55:18.058477+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	12
a5b1cffe-fd5c-40a2-af12-6710070dcd23	12	2025-01-19 02:55:34.214223+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	1212
c896855a-8058-4f29-8959-4ba7ee172635	121	2025-01-19 02:55:46.719189+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	121211
e7a8008f-c8b0-4890-bf0b-dd99b6bdfd77	Kg	2025-01-19 02:57:36.913993+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	Jon
ac245503-be49-4e24-98da-c89ba79edb5a	Kg	2025-01-19 02:58:03.581454+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	Ikhwan
ba121bef-0598-479f-b731-da63b2fe21e8	kg	2025-01-19 02:58:26.998398+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	askmarker
6fe86e6e-3084-48d7-97d3-9520a75c026c	odl	2025-01-28 08:05:01.958502+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	iooo67
f529e5c0-83e1-4aac-9ae7-382881d3957b	KG	2025-03-16 06:08:49.695675+00	85239af0-2860-4e35-9f6f-5aa79a10ceb7	Kiloan - Cuci
e3977a1c-a919-44c6-a2b4-178ae2c1cf80	PCS	2025-03-16 06:08:49.695675+00	85239af0-2860-4e35-9f6f-5aa79a10ceb7	Jas
84c459f7-426a-4934-85f2-bf87067bffe7	dskd	2025-01-29 04:16:32.100247+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	dksjd
e3bab34f-a7cd-425f-ab5e-ac7451cfcad1	PCS	2025-03-16 06:08:49.695675+00	85239af0-2860-4e35-9f6f-5aa79a10ceb7	Boneka
9406b6dd-3ee6-4ce7-84f6-3ee3e850d2bc	PCS	2025-03-16 06:08:49.695675+00	85239af0-2860-4e35-9f6f-5aa79a10ceb7	Bedcover
3aea9d26-db35-48b9-b662-7bffeea608d0	PCS	2025-03-16 06:08:49.695675+00	85239af0-2860-4e35-9f6f-5aa79a10ceb7	Selimut
2da5d742-44e3-4537-908b-00ddbadc8a46	io	2025-01-29 07:20:01.363061+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	kkk
7e9dd14a-04f9-4ee2-89aa-0f06d56d69ad	T	2025-01-29 00:52:03.031449+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	Yuuuuu
137d5b80-a174-432d-acbf-723bdbd0f389	Yuuu	2025-02-17 07:40:26.955531+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	Hehe
0c6f5479-3ddc-4df8-b887-9044c1d0d6a9	Kg	2025-03-07 12:43:52.697443+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	Yuy
995b7863-4eb7-4f2f-b02c-c85b762ffb68	osadk	2025-03-07 13:00:25.20816+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	oadao
d0af25e2-ef39-429b-855d-b393a500894b	ISAKS	2025-03-07 13:01:24.220863+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	lakas
b57b3464-80f0-490f-8eaf-d1c509148151	isj	2025-03-07 13:02:24.549092+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	jsdk
3c51c003-b6e0-4b36-bdca-a84c7d27bd7e	ial	2025-03-07 13:02:40.628038+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	osk
fd7c2970-cb3b-4230-bd58-3f9cfac29c82	oa	2025-03-07 13:03:00.614279+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	ids
12134389-7bea-4f18-870d-ab2bb41944dd	iao	2025-03-07 13:03:52.209002+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	clskd
6ae4fa1c-62e6-4e69-8f7b-99868caf2ac3	u	2025-03-07 13:04:13.310885+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	ixh
fa83745e-e2d3-45b2-80f8-8c6a7f8f84d9	KG	2025-03-16 07:23:02.018489+00	b33dc683-b9ad-4eb6-8b38-53250b250cc6	Kiloan - Cuci, Setrika
d571725c-5ebd-4d1c-bfdf-dad125b55c58	KG	2025-03-16 07:23:02.018489+00	b33dc683-b9ad-4eb6-8b38-53250b250cc6	Kiloan - Cuci
5e0c5fc1-558a-4198-9019-5d7914d164a6	PCS	2025-03-16 07:23:02.018489+00	b33dc683-b9ad-4eb6-8b38-53250b250cc6	Jas
9c98fe1c-8467-4e3e-a90f-f25044b16c2b	PCS	2025-03-16 07:23:02.018489+00	b33dc683-b9ad-4eb6-8b38-53250b250cc6	Boneka
5a4a4700-286c-4ccd-a00f-781a1dc2521e	PCS	2025-03-16 07:23:02.018489+00	b33dc683-b9ad-4eb6-8b38-53250b250cc6	Bedcover
9b1fd099-8793-4368-9cdf-73565dc9244f	PCS	2025-03-16 07:23:02.018489+00	b33dc683-b9ad-4eb6-8b38-53250b250cc6	Selimut
7a4308e0-95f1-4c6c-8bb9-340ab32f7037	KG	2025-03-17 11:04:06.779175+00	68711dbd-970a-4517-b999-1a47df6c550e	Kiloan - Cuci, Setrika
a9d0e4f3-75ac-4356-9832-f50d04343c9b	KG	2025-03-17 11:04:06.779175+00	68711dbd-970a-4517-b999-1a47df6c550e	Kiloan - Cuci
1e133026-6c7d-4355-86d5-8fbe497cad26	PCS	2025-03-17 11:04:06.779175+00	68711dbd-970a-4517-b999-1a47df6c550e	Jas
8bf76fec-375a-4851-b791-00daa5e355c7	PCS	2025-03-17 11:04:06.779175+00	68711dbd-970a-4517-b999-1a47df6c550e	Boneka
eabfbd54-8fd3-400b-b610-44e60dd5576e	PCS	2025-03-17 11:04:06.779175+00	68711dbd-970a-4517-b999-1a47df6c550e	Bedcover
728a11a6-c5d4-4c86-bea9-5d048d00bcb1	PCS	2025-03-17 11:04:06.779175+00	68711dbd-970a-4517-b999-1a47df6c550e	Selimut
f3805087-ec88-46fa-b844-cbb60f28c427	KG	2025-03-17 12:55:08.283189+00	9123b156-5e22-44b6-b7fa-a8c76a51f178	Kiloan - Cuci, Setrika
a43759e4-f70f-40cf-a16b-f9c81b9d1137	KG	2025-03-17 12:55:08.283189+00	9123b156-5e22-44b6-b7fa-a8c76a51f178	Kiloan - Cuci
10a3accc-cb40-4113-aa78-7bd19a42dc48	PCS	2025-03-17 12:55:08.283189+00	9123b156-5e22-44b6-b7fa-a8c76a51f178	Jas
95444c97-4a99-462b-ae08-bce4df2c8128	PCS	2025-03-17 12:55:08.283189+00	9123b156-5e22-44b6-b7fa-a8c76a51f178	Boneka
8ee92283-5063-408e-9766-0f923be834d3	PCS	2025-03-17 12:55:08.283189+00	9123b156-5e22-44b6-b7fa-a8c76a51f178	Bedcover
0c66962d-da42-41a5-9037-6e752122f370	PCS	2025-03-17 12:55:08.283189+00	9123b156-5e22-44b6-b7fa-a8c76a51f178	Selimut
a6914f53-f97e-48c0-a303-b99407203eec	KG	2025-03-19 06:52:50.030774+00	9e80ef92-c070-4cc5-b5f3-060f347d2c87	Kiloan - Cuci, Setrika
d4f68248-ef01-4a21-aa7e-87edbb40e172	KG	2025-03-19 06:52:50.030774+00	9e80ef92-c070-4cc5-b5f3-060f347d2c87	Kiloan - Cuci
33e1f400-6336-4eb2-af25-2a80cb51bedb	PCS	2025-03-19 06:52:50.030774+00	9e80ef92-c070-4cc5-b5f3-060f347d2c87	Jas
f3761434-33c5-4849-9d76-87a8b4f4e48d	PCS	2025-03-19 06:52:50.030774+00	9e80ef92-c070-4cc5-b5f3-060f347d2c87	Boneka
d386b90e-fa0e-41d3-9be0-2c0bc01c6ede	PCS	2025-03-19 06:52:50.030774+00	9e80ef92-c070-4cc5-b5f3-060f347d2c87	Bedcover
4a2788a1-8766-4d00-b914-2676d650bccc	PCS	2025-03-19 06:52:50.030774+00	9e80ef92-c070-4cc5-b5f3-060f347d2c87	Selimut
c4bb3d2b-b63d-4863-854d-3960997cf14f	KG	2025-03-19 07:03:24.917247+00	0fed73db-0c6d-4f95-a913-48b1131595fc	Kiloan - Cuci, Setrika
941f2f91-9ec2-46fc-ad09-e01fd0426b08	KG	2025-03-19 07:03:24.917247+00	0fed73db-0c6d-4f95-a913-48b1131595fc	Kiloan - Cuci
2a7eeb2f-9be5-48c9-a280-5e8c4723b6ca	PCS	2025-03-19 07:03:24.917247+00	0fed73db-0c6d-4f95-a913-48b1131595fc	Jas
42aeef51-0daa-4417-80c8-d01392476562	PCS	2025-03-19 07:03:24.917247+00	0fed73db-0c6d-4f95-a913-48b1131595fc	Boneka
ed88d2bf-3d84-4bdd-9f07-bfbcc137fcae	PCS	2025-03-19 07:03:24.917247+00	0fed73db-0c6d-4f95-a913-48b1131595fc	Bedcover
1a3cb704-c6d0-4c89-b2a6-662ef333d424	PCS	2025-03-19 07:03:24.917247+00	0fed73db-0c6d-4f95-a913-48b1131595fc	Selimut
a62e1f00-2412-4fd6-b5b0-5a5f31f2c1f7	KG	2025-03-19 14:08:06.83541+00	e231be7c-213e-4500-b437-e7ed94f468a7	Kiloan - Cuci, Setrika
145c45f4-b595-49bd-8158-e07d5f88972d	KG	2025-03-19 14:08:06.83541+00	e231be7c-213e-4500-b437-e7ed94f468a7	Kiloan - Cuci
a8f15201-9cbc-406e-adb5-52af094caf7e	PCS	2025-03-19 14:08:06.83541+00	e231be7c-213e-4500-b437-e7ed94f468a7	Jas
62496ba5-8a9f-4aec-b7a2-05757f7cfad4	PCS	2025-03-19 14:08:06.83541+00	e231be7c-213e-4500-b437-e7ed94f468a7	Boneka
77296b8b-8e01-4b7a-a2f8-bdd70155c3fe	PCS	2025-03-19 14:08:06.83541+00	e231be7c-213e-4500-b437-e7ed94f468a7	Bedcover
4f9808a6-8b46-47fc-9db5-a50600fd8392	PCS	2025-03-19 14:08:06.83541+00	e231be7c-213e-4500-b437-e7ed94f468a7	Selimut
0a3de9ff-648b-4b16-a621-7d734db64d6e	KG	2025-03-19 22:04:24.561145+00	530de47b-18ce-4200-865f-fece556044c2	Kiloan - Cuci, Setrika
e2ee1d30-d396-4b89-8964-e87949d351c4	KG	2025-03-19 22:04:24.561145+00	530de47b-18ce-4200-865f-fece556044c2	Kiloan - Cuci
7de5f2ec-a549-4544-b467-2b69b9daf4a6	PCS	2025-03-19 22:04:24.561145+00	530de47b-18ce-4200-865f-fece556044c2	Jas
00b743b6-9011-40bf-a904-89a7af010126	PCS	2025-03-19 22:04:24.561145+00	530de47b-18ce-4200-865f-fece556044c2	Boneka
33331d29-0ba4-4731-9ffc-404d6e80e754	PCS	2025-03-19 22:04:24.561145+00	530de47b-18ce-4200-865f-fece556044c2	Bedcover
a9601ae1-016e-4d5b-9510-9399533dca9e	PCS	2025-03-19 22:04:24.561145+00	530de47b-18ce-4200-865f-fece556044c2	Selimut
25efee98-befa-466d-af62-03f23a8f8243	KG	2025-03-23 02:52:01.083343+00	8ea1e721-d977-412f-86fb-17585368a773	Kiloan - Cuci, Setrika
e89bd934-db73-480a-a596-3ea6c4f9b9ee	KG	2025-03-23 02:52:01.083343+00	8ea1e721-d977-412f-86fb-17585368a773	Kiloan - Cuci
f28b12aa-910f-4912-96dc-00d871544cb7	PCS	2025-03-23 02:52:01.083343+00	8ea1e721-d977-412f-86fb-17585368a773	Jas
163c0f6c-37d0-409a-be25-29ceff23c87b	PCS	2025-03-23 02:52:01.083343+00	8ea1e721-d977-412f-86fb-17585368a773	Boneka
6a3810b5-87e1-4cf9-b838-6606e25afea9	PCS	2025-03-23 02:52:01.083343+00	8ea1e721-d977-412f-86fb-17585368a773	Bedcover
069a6d70-bc91-40d2-84b5-2bced4bce078	PCS	2025-03-23 02:52:01.083343+00	8ea1e721-d977-412f-86fb-17585368a773	Selimut
8aef4326-0c57-4ec6-954a-97eb2a3fc352	KG	2025-03-23 03:13:17.911407+00	7e2288a2-3004-4784-aac2-a3c2fb4155f9	Kiloan - Cuci, Setrika
f8475c7a-868a-4a99-9acf-6756f0924e58	KG	2025-03-23 03:13:17.911407+00	7e2288a2-3004-4784-aac2-a3c2fb4155f9	Kiloan - Cuci
2ad0f7ed-e42a-4228-a5b0-fff08ee452df	PCS	2025-03-23 03:13:17.911407+00	7e2288a2-3004-4784-aac2-a3c2fb4155f9	Jas
4933df24-0865-49eb-a89c-14484cdac00f	PCS	2025-03-23 03:13:17.911407+00	7e2288a2-3004-4784-aac2-a3c2fb4155f9	Boneka
2e3755d8-d524-461f-bc1e-1047d13b5943	PCS	2025-03-23 03:13:17.911407+00	7e2288a2-3004-4784-aac2-a3c2fb4155f9	Bedcover
17693149-4d1c-4eb3-befa-38f941444a88	PCS	2025-03-23 03:13:17.911407+00	7e2288a2-3004-4784-aac2-a3c2fb4155f9	Selimut
8b5bf2dc-0eca-4f0c-884f-a8a12f8d61d7	KG	2025-03-23 04:02:29.701547+00	a2eed2f1-b740-4512-8d71-368c2df49c59	Kiloan - Cuci, Setrika
58d0ea44-61c0-4b85-b522-073be2ed4afc	KG	2025-03-23 04:02:29.701547+00	a2eed2f1-b740-4512-8d71-368c2df49c59	Kiloan - Cuci
a12eda9a-a08d-4508-a2d2-9446ed64ba7e	PCS	2025-03-23 04:02:29.701547+00	a2eed2f1-b740-4512-8d71-368c2df49c59	Jas
95a06c55-3ca4-4a8b-8970-a78c72e38793	PCS	2025-03-23 04:02:29.701547+00	a2eed2f1-b740-4512-8d71-368c2df49c59	Boneka
56b96f48-efcc-4046-b6a4-adc6c6674b9f	PCS	2025-03-23 04:02:29.701547+00	a2eed2f1-b740-4512-8d71-368c2df49c59	Bedcover
3b4e6dce-84d2-4180-b160-e29174bcccbc	PCS	2025-03-23 04:02:29.701547+00	a2eed2f1-b740-4512-8d71-368c2df49c59	Selimut
5a849234-30a5-457d-b788-b4bd17981bf8	KG	2025-04-06 02:10:23.405726+00	563694c4-3b7f-4a17-accd-f42f40131373	Kiloan - Cuci, Setrika
e5b517bf-c631-4b1e-b386-746ccaa32f5c	KG	2025-04-06 02:10:23.405726+00	563694c4-3b7f-4a17-accd-f42f40131373	Kiloan - Cuci
ba344ce6-172f-427f-84d4-7b436fdc9a9e	PCS	2025-04-06 02:10:23.405726+00	563694c4-3b7f-4a17-accd-f42f40131373	Jas
866ee5fe-80b1-4b43-ae2b-7103b0f0e892	PCS	2025-04-06 02:10:23.405726+00	563694c4-3b7f-4a17-accd-f42f40131373	Boneka
3b93db64-46c0-4772-b951-2449cb26b227	PCS	2025-04-06 02:10:23.405726+00	563694c4-3b7f-4a17-accd-f42f40131373	Bedcover
2023f099-6ca8-43bf-850c-7d08c9759cb4	PCS	2025-04-06 02:10:23.405726+00	563694c4-3b7f-4a17-accd-f42f40131373	Selimut
8d4e3ed7-351c-4453-8fc2-79ac0b79ad9a	KG	2025-04-13 10:21:02.546568+00	e32ad1af-905e-4781-86ae-389edd96ff9d	Kiloan - Cuci, Setrika
a8174ca4-afc6-4b47-af24-7b36ee61c5b3	KG	2025-04-13 10:21:02.546568+00	e32ad1af-905e-4781-86ae-389edd96ff9d	Kiloan - Cuci
c49671f7-7049-48f7-b80a-f4e919a5b1ce	PCS	2025-04-13 10:21:02.546568+00	e32ad1af-905e-4781-86ae-389edd96ff9d	Jas
d9613ec9-8107-42eb-a872-8df47b415805	PCS	2025-04-13 10:21:02.546568+00	e32ad1af-905e-4781-86ae-389edd96ff9d	Boneka
927b5cd7-2ae4-4264-a275-975e755cdc6b	PCS	2025-04-13 10:21:02.546568+00	e32ad1af-905e-4781-86ae-389edd96ff9d	Bedcover
5c15aba7-9efc-40a9-85bd-506fdb84e14d	PCS	2025-04-13 10:21:02.546568+00	e32ad1af-905e-4781-86ae-389edd96ff9d	Selimut
2910e48e-2e95-4552-badc-b2809512d2c5	Test	2025-04-20 03:36:43.785325+00	851d6597-49ca-4ec0-8ca9-2a714c68554f	Test
2c1ae9db-3262-461a-8543-028ca9a114fc	KG	2025-04-27 12:39:10.229862+00	ae3cc332-1d0e-4af9-bf90-c4047370fc63	Kiloan - Cuci, Setrika
f9799abd-45b3-48dc-a781-7c06d5539182	KG	2025-04-27 12:39:10.229862+00	ae3cc332-1d0e-4af9-bf90-c4047370fc63	Kiloan - Cuci
51f611e7-af3e-4c61-8aab-1f67448e6f68	PCS	2025-04-27 12:39:10.229862+00	ae3cc332-1d0e-4af9-bf90-c4047370fc63	Jas
9288f044-5d19-4ffb-9a0f-86fe5d93c71e	PCS	2025-04-27 12:39:10.229862+00	ae3cc332-1d0e-4af9-bf90-c4047370fc63	Boneka
f7ead5a3-1574-4439-a4a4-c400dd50aa6e	PCS	2025-04-27 12:39:10.229862+00	ae3cc332-1d0e-4af9-bf90-c4047370fc63	Bedcover
88093b9e-b6f4-4e83-b3cd-f37377812a4a	PCS	2025-04-27 12:39:10.229862+00	ae3cc332-1d0e-4af9-bf90-c4047370fc63	Selimut
31ab0b7a-2fb0-418a-a521-eccffbecbdcb	KG	2025-04-27 12:44:34.319161+00	d73cfd09-e4ca-415d-880b-d5944c8a04df	Kiloan - Cuci, Setrika
c0e756d2-8a46-45ad-b546-531ce0f34b24	KG	2025-04-27 12:44:34.319161+00	d73cfd09-e4ca-415d-880b-d5944c8a04df	Kiloan - Cuci
af5b8af7-f532-4220-8e60-d59541db622c	PCS	2025-04-27 12:44:34.319161+00	d73cfd09-e4ca-415d-880b-d5944c8a04df	Jas
baf9f542-e191-4bc6-9928-90ccb94fc860	PCS	2025-04-27 12:44:34.319161+00	d73cfd09-e4ca-415d-880b-d5944c8a04df	Boneka
6bbcfa67-23f6-45de-883a-f7d85eed08f6	PCS	2025-04-27 12:44:34.319161+00	d73cfd09-e4ca-415d-880b-d5944c8a04df	Bedcover
f370b869-9338-436f-8ba4-e52867475cca	PCS	2025-04-27 12:44:34.319161+00	d73cfd09-e4ca-415d-880b-d5944c8a04df	Selimut
a7265ca4-972f-4cfb-a680-156a8c20121c	KG	2025-04-29 06:42:30.746304+00	ab309022-bcc9-4e04-8abc-d61c4afd3416	Kiloan - Cuci, Setrika
674c2171-e324-4069-97a3-5a0c4df463b9	KG	2025-04-29 06:42:30.746304+00	ab309022-bcc9-4e04-8abc-d61c4afd3416	Kiloan - Cuci
a9bfc68c-1220-4834-9ca5-5c50de6abb6a	PCS	2025-04-29 06:42:30.746304+00	ab309022-bcc9-4e04-8abc-d61c4afd3416	Jas
6ef02098-9db2-4488-9051-fa0328c0d3b7	PCS	2025-04-29 06:42:30.746304+00	ab309022-bcc9-4e04-8abc-d61c4afd3416	Boneka
1c87ab0f-8c06-4e9a-b6a3-c9a7532e4352	PCS	2025-04-29 06:42:30.746304+00	ab309022-bcc9-4e04-8abc-d61c4afd3416	Bedcover
fa687718-04a9-4d70-bd36-6994c008f814	PCS	2025-04-29 06:42:30.746304+00	ab309022-bcc9-4e04-8abc-d61c4afd3416	Selimut
ea8e0e0b-53f1-4ac3-8b74-866ae12874e4	KG	2025-05-01 14:30:59.616206+00	f12d64af-30ce-46bb-821e-8dd6b9eec514	Kiloan - Cuci, Setrika
a250ac37-e919-4708-85ac-77eef8be077c	KG	2025-05-01 14:30:59.616206+00	f12d64af-30ce-46bb-821e-8dd6b9eec514	Kiloan - Cuci
2974d905-74f3-4217-ba00-aba97d091019	PCS	2025-05-01 14:30:59.616206+00	f12d64af-30ce-46bb-821e-8dd6b9eec514	Jas
27998903-88ba-4a9d-b233-7bdd4cb476db	PCS	2025-05-01 14:30:59.616206+00	f12d64af-30ce-46bb-821e-8dd6b9eec514	Boneka
761b6400-61dc-4fd3-b1a5-70efa2eb8afa	PCS	2025-05-01 14:30:59.616206+00	f12d64af-30ce-46bb-821e-8dd6b9eec514	Bedcover
035f9073-af4e-4a1d-bebd-cc0a6cc98e84	PCS	2025-05-01 14:30:59.616206+00	f12d64af-30ce-46bb-821e-8dd6b9eec514	Selimut
bdddf168-4650-4bc0-87cd-b2fb8b037af6	KG	2025-05-01 14:42:42.602641+00	a145d8a1-8899-4a15-90a2-bc20da194e04	Kiloan - Cuci, Setrika
30934528-6a17-4eb2-aa2a-03bec5f7ca50	KG	2025-05-01 14:42:42.602641+00	a145d8a1-8899-4a15-90a2-bc20da194e04	Kiloan - Cuci
d34d73dc-1773-4ca9-865b-ded8ad76a388	PCS	2025-05-01 14:42:42.602641+00	a145d8a1-8899-4a15-90a2-bc20da194e04	Jas
2f72ef2d-ef36-4cd2-9f12-ca36899d36d3	PCS	2025-05-01 14:42:42.602641+00	a145d8a1-8899-4a15-90a2-bc20da194e04	Boneka
0bbb46ad-1ce3-49c0-8e95-a64f064be09f	PCS	2025-05-01 14:42:42.602641+00	a145d8a1-8899-4a15-90a2-bc20da194e04	Bedcover
0b9e1e68-3477-4801-b43b-4b0651d080da	PCS	2025-05-01 14:42:42.602641+00	a145d8a1-8899-4a15-90a2-bc20da194e04	Selimut
d7973deb-180b-438f-a451-1ea2ac8fb5c1	KG	2025-05-01 14:44:04.795594+00	b1b00121-0f27-43b2-aa80-5d2094bfff62	Kiloan - Cuci, Setrika
60c2796e-e621-4103-a2d1-cb2faa03f47d	KG	2025-05-01 14:44:04.795594+00	b1b00121-0f27-43b2-aa80-5d2094bfff62	Kiloan - Cuci
4ec9d514-cee8-4155-ae6b-3b43ff53eea0	PCS	2025-05-01 14:44:04.795594+00	b1b00121-0f27-43b2-aa80-5d2094bfff62	Jas
21432e22-8af2-4acb-aed0-6d6c2e96b3a7	PCS	2025-05-01 14:44:04.795594+00	b1b00121-0f27-43b2-aa80-5d2094bfff62	Boneka
f3c31070-7c3a-4197-95b1-e59a9aaa36c1	PCS	2025-05-01 14:44:04.795594+00	b1b00121-0f27-43b2-aa80-5d2094bfff62	Bedcover
8900f2ad-aec8-4a7b-be57-d33cc5c90eb1	PCS	2025-05-01 14:44:04.795594+00	b1b00121-0f27-43b2-aa80-5d2094bfff62	Selimut
02d33e9d-30cf-4ef6-8094-fa21cc6a1cd4	KG	2025-05-01 14:44:44.123883+00	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	Kiloan - Cuci, Setrika
96be692b-edbc-4760-9404-291d0c8f2a74	KG	2025-05-01 14:44:44.123883+00	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	Kiloan - Cuci
1cba3994-4d1c-4792-a15d-589de4b820c7	PCS	2025-05-01 14:44:44.123883+00	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	Jas
0794a308-c78b-4d23-a1d4-c80d2d781fc7	PCS	2025-05-01 14:44:44.123883+00	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	Boneka
d83b98fe-b532-4c5f-bcfe-db59b962ac08	PCS	2025-05-01 14:44:44.123883+00	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	Bedcover
506c9629-af12-401a-bfc3-ac702266a399	PCS	2025-05-01 14:44:44.123883+00	84a381ce-bdb0-49aa-a70c-4e0c6b28197a	Selimut
f336b3cf-b4b7-4af3-8c03-9b012f275da7	KG	2025-05-01 14:48:09.342027+00	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	Kiloan - Cuci, Setrika
81fea502-9a08-4ec0-9476-c630da7d4635	KG	2025-05-01 14:48:09.342027+00	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	Kiloan - Cuci
f72504f7-0a83-44e3-9e83-efbcf0cf8c91	PCS	2025-05-01 14:48:09.342027+00	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	Jas
5c1ba802-9ea9-437d-bb7b-600ee83d4092	PCS	2025-05-01 14:48:09.342027+00	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	Boneka
c02a281f-b04e-4122-bed3-0a9298ffd88c	PCS	2025-05-01 14:48:09.342027+00	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	Bedcover
8f646dcf-755d-4b73-91df-49e372628e43	PCS	2025-05-01 14:48:09.342027+00	ce3770d4-edc3-4fc5-9084-d7b72fca3a64	Selimut
a2563c6e-a38c-4441-ab5c-5147ebcf254e	KG	2025-05-01 15:07:25.412782+00	8be70116-5bc2-4a51-a3b5-5001739899ae	Kiloan - Cuci, Setrika
03d00293-9dde-4979-abe1-941f3ab67920	KG	2025-05-01 15:07:25.412782+00	8be70116-5bc2-4a51-a3b5-5001739899ae	Kiloan - Cuci
e39d33ae-2e44-461f-8e02-3e03841e84b4	PCS	2025-05-01 15:07:25.412782+00	8be70116-5bc2-4a51-a3b5-5001739899ae	Jas
ca55f977-03b1-4f62-a3e1-903e864bfadb	PCS	2025-05-01 15:07:25.412782+00	8be70116-5bc2-4a51-a3b5-5001739899ae	Boneka
0faf7d13-5e06-42df-b8bb-a2f2f1e3da4d	PCS	2025-05-01 15:07:25.412782+00	8be70116-5bc2-4a51-a3b5-5001739899ae	Bedcover
e1840b3e-19c9-4700-a19b-c61f236ce713	PCS	2025-05-01 15:07:25.412782+00	8be70116-5bc2-4a51-a3b5-5001739899ae	Selimut
329bd32c-6809-42c8-92f0-99362823b924	KG	2025-05-04 07:08:58.165851+00	ff9c0083-6186-40e8-b24a-0801bec4e4f4	Kiloan - Cuci, Setrika
92396a1d-32bd-4d5a-8cfa-6483a2cc212f	KG	2025-05-04 07:08:58.165851+00	ff9c0083-6186-40e8-b24a-0801bec4e4f4	Kiloan - Cuci
f0be335c-db79-43f7-94b4-4340cee103df	PCS	2025-05-04 07:08:58.165851+00	ff9c0083-6186-40e8-b24a-0801bec4e4f4	Jas
833fd926-e562-408d-9e11-a2fc4dd95475	PCS	2025-05-04 07:08:58.165851+00	ff9c0083-6186-40e8-b24a-0801bec4e4f4	Boneka
44bcd28a-e3ac-4687-8c55-4ffe4040a0db	PCS	2025-05-04 07:08:58.165851+00	ff9c0083-6186-40e8-b24a-0801bec4e4f4	Bedcover
89b15111-9f60-44ac-8b4e-b9bd94c04926	PCS	2025-05-04 07:08:58.165851+00	ff9c0083-6186-40e8-b24a-0801bec4e4f4	Selimut
bcdaaa49-103e-4753-8d1f-86849e636064	KG	2025-05-21 03:00:59.278422+00	490e65e1-0159-4a63-855c-b3ed8e621ef4	Kiloan - Cuci, Setrika
f4b7ea35-198d-4212-b683-a4e40a8b7910	KG	2025-05-21 03:00:59.278422+00	490e65e1-0159-4a63-855c-b3ed8e621ef4	Kiloan - Cuci
ef5025ea-4b6b-4a7d-9a29-f4d4398525d3	PCS	2025-05-21 03:00:59.278422+00	490e65e1-0159-4a63-855c-b3ed8e621ef4	Jas
403229fa-c9fd-407a-89f3-f8c211623943	PCS	2025-05-21 03:00:59.278422+00	490e65e1-0159-4a63-855c-b3ed8e621ef4	Boneka
bf50b3e3-5d1c-4cb1-af92-d27f1b7abdf8	PCS	2025-05-21 03:00:59.278422+00	490e65e1-0159-4a63-855c-b3ed8e621ef4	Bedcover
cd30dd26-a409-4a85-9dcd-34c053c31570	PCS	2025-05-21 03:00:59.278422+00	490e65e1-0159-4a63-855c-b3ed8e621ef4	Selimut
4b628038-6129-4e40-bb49-2243db2a3188	KG	2025-05-25 13:38:03.846639+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Kiloan - Cuci, Setrika
2856178c-806a-4f2d-90c8-63f05bddb27b	KG	2025-05-25 13:38:03.846639+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Kiloan - Cuci
0b4aa7fc-fcbc-4adc-8cec-0a8ee4adb70a	PCS	2025-05-25 13:38:03.846639+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Jas
da09f17a-677b-4f34-a3cf-8cb1f1258ae4	PCS	2025-05-25 13:38:03.846639+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Bedcover
83de7f21-9ecc-47e2-8bf4-65fcb8e92434	PCS	2025-05-25 13:38:03.846639+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Selimut
5f27c019-0934-4727-b1f4-442e11515160	KG	2025-06-14 11:16:09.71107+00	704b9e26-e5ce-4f92-9b5d-ded4eecace01	Kiloan - Cuci, Setrika
eafc06e4-4c24-4cd0-9871-82a714e92a7c	KG	2025-06-14 11:16:09.71107+00	704b9e26-e5ce-4f92-9b5d-ded4eecace01	Kiloan - Cuci
c461ad73-443e-4037-a583-6ab856f7198b	PCS	2025-06-14 11:16:09.71107+00	704b9e26-e5ce-4f92-9b5d-ded4eecace01	Jas
88fdd366-6ec2-4be9-8320-cb85984893b5	PCS	2025-06-14 11:16:09.71107+00	704b9e26-e5ce-4f92-9b5d-ded4eecace01	Boneka
4d012e22-2ba5-4fb3-a676-bddc9c868032	PCS	2025-06-14 11:16:09.71107+00	704b9e26-e5ce-4f92-9b5d-ded4eecace01	Bedcover
0428cdcd-bbcc-4461-be92-f01ccd06fb0a	PCS	2025-06-14 11:16:09.71107+00	704b9e26-e5ce-4f92-9b5d-ded4eecace01	Selimut
34f82a36-168a-404c-a99e-78db5b8a1aff	KG	2025-06-14 11:30:20.804019+00	5f892fcb-c56a-4059-ba66-e581e45e3a67	Kiloan - Cuci, Setrika
01b44e66-bf43-4fb8-99ae-d65ea0c27e0b	KG	2025-06-14 11:30:20.804019+00	5f892fcb-c56a-4059-ba66-e581e45e3a67	Kiloan - Cuci
64a9efa0-8fd7-4962-862a-af801daf6362	PCS	2025-06-14 11:30:20.804019+00	5f892fcb-c56a-4059-ba66-e581e45e3a67	Jas
273b2f24-10a8-49ef-b08a-325d6d81a369	PCS	2025-06-14 11:30:20.804019+00	5f892fcb-c56a-4059-ba66-e581e45e3a67	Boneka
6abbf49c-2414-45ee-b58a-42d5b500e323	PCS	2025-06-14 11:30:20.804019+00	5f892fcb-c56a-4059-ba66-e581e45e3a67	Bedcover
d34239c1-a465-4711-ac87-3b35893efba4	PCS	2025-06-14 11:30:20.804019+00	5f892fcb-c56a-4059-ba66-e581e45e3a67	Selimut
d52135f4-a1c8-4256-bf3a-a07efde5579d	KG	2025-06-14 11:46:02.198027+00	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	Kiloan - Cuci, Setrika
93e4cda0-1194-4ce5-8374-73a1ed103294	KG	2025-06-14 11:46:02.198027+00	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	Kiloan - Cuci
9dfd99d7-f13f-44ac-abef-49ae502e5183	PCS	2025-06-14 11:46:02.198027+00	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	Jas
d4db4be0-a56b-4ab2-9768-dbde438f53d3	PCS	2025-06-14 11:46:02.198027+00	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	Boneka
39a2098e-3769-4e07-99a4-0a2795e21f25	PCS	2025-06-14 11:46:02.198027+00	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	Bedcover
8c04f403-4cca-449c-86ab-a3ce267422e5	PCS	2025-06-14 11:46:02.198027+00	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	Selimut
610b97f4-bd13-489c-920f-ebf903ade076	KG	2025-06-14 11:48:28.089577+00	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	Kiloan - Cuci, Setrika
15959fcf-6fb0-4719-a09b-2ce47562700b	KG	2025-06-14 11:48:28.089577+00	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	Kiloan - Cuci
5623a90d-ac3d-4c42-b60c-b006cf5b640c	PCS	2025-06-14 11:48:28.089577+00	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	Jas
454d673e-c28c-4400-9ec3-89ef0592181c	PCS	2025-06-14 11:48:28.089577+00	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	Boneka
f72db239-2733-4493-9f83-eaed2e6125bb	PCS	2025-06-14 11:48:28.089577+00	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	Bedcover
b55cef53-1215-4473-b783-bdaf706a5442	PCS	2025-06-14 11:48:28.089577+00	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	Selimut
f8295cf3-8a3c-40f1-8598-8ee31c8091b3	KG	2025-06-14 11:49:25.638803+00	3cf34541-51de-42f8-9c16-5b95020d9fff	Kiloan - Cuci, Setrika
ac85c022-b3c9-4359-a1e0-15b2b4e09755	KG	2025-06-14 11:49:25.638803+00	3cf34541-51de-42f8-9c16-5b95020d9fff	Kiloan - Cuci
1405a614-4307-4ea9-bdc3-a648c1b02392	PCS	2025-06-14 11:49:25.638803+00	3cf34541-51de-42f8-9c16-5b95020d9fff	Jas
6de5d5a7-d097-495f-8335-66df0e6f1096	PCS	2025-06-14 11:49:25.638803+00	3cf34541-51de-42f8-9c16-5b95020d9fff	Boneka
3beff625-0bfb-4000-9d02-1c9f0482aa3b	PCS	2025-06-14 11:49:25.638803+00	3cf34541-51de-42f8-9c16-5b95020d9fff	Bedcover
f965c478-fb9d-4c42-8815-8150776af29a	PCS	2025-06-14 11:49:25.638803+00	3cf34541-51de-42f8-9c16-5b95020d9fff	Selimut
e3617730-b93a-4414-a419-f0083705190f	KG	2025-06-15 03:16:52.249521+00	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	Kiloan - Cuci, Setrika
c6dfda8e-b3a5-4103-af9f-deb7db5bb403	KG	2025-06-15 03:16:52.249521+00	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	Kiloan - Cuci
817157c3-c41d-4578-ab1d-361cd49d4bd7	PCS	2025-06-15 03:16:52.249521+00	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	Jas
ce9d43df-4384-42f8-af2f-68dd8af4ebc9	PCS	2025-06-15 03:16:52.249521+00	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	Boneka
ca178f38-09c5-4835-afe5-b44483bfcaa5	PCS	2025-06-15 03:16:52.249521+00	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	Bedcover
e63fbbbf-dcd3-463e-8e59-fd71af5d2a7d	PCS	2025-06-15 03:16:52.249521+00	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	Selimut
f22d1eec-f9c3-4bfc-8794-f4a143851d98	KG	2025-06-15 03:18:59.694843+00	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	Kiloan - Cuci, Setrika
57afe291-332a-4b3c-8d64-1f2536d531bc	KG	2025-06-15 03:18:59.694843+00	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	Kiloan - Cuci
d0db260f-1157-42b9-98e3-5096da6354ad	PCS	2025-06-15 03:18:59.694843+00	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	Jas
068a3789-571a-40d4-b9a2-7529e8f87ee9	PCS	2025-06-15 03:18:59.694843+00	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	Boneka
e6bd7ac4-dace-4b32-bf67-e373f705c8c1	PCS	2025-06-15 03:18:59.694843+00	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	Bedcover
a3190994-586f-41e7-9f9b-dfcf3db3b057	PCS	2025-06-15 03:18:59.694843+00	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	Selimut
2bd4b9ce-c924-4d4f-803d-7d553314d5ac	KG	2025-06-15 03:20:21.276696+00	ddc18a20-f5e5-48d3-a94d-9febac756a86	Kiloan - Cuci, Setrika
8197274e-a101-49c8-8847-7bf8d7f1b1d5	KG	2025-06-15 03:20:21.276696+00	ddc18a20-f5e5-48d3-a94d-9febac756a86	Kiloan - Cuci
bab86748-1d04-42a1-ba65-4935d566a646	PCS	2025-06-15 03:20:21.276696+00	ddc18a20-f5e5-48d3-a94d-9febac756a86	Jas
c7f97945-8c5b-4923-ac30-40c7fea95dd5	PCS	2025-06-15 03:20:21.276696+00	ddc18a20-f5e5-48d3-a94d-9febac756a86	Boneka
59f963b9-c948-4481-ab66-82ade2ffd74f	PCS	2025-06-15 03:20:21.276696+00	ddc18a20-f5e5-48d3-a94d-9febac756a86	Bedcover
90b398f6-018b-41ec-a302-0263040c9145	PCS	2025-06-15 03:20:21.276696+00	ddc18a20-f5e5-48d3-a94d-9febac756a86	Selimut
4cfd2184-82a5-4894-acdd-902339a90e9b	KG	2025-06-15 03:26:37.883854+00	8bd96235-350d-4f6f-9489-3f80122e1c77	Kiloan - Cuci, Setrika
50cb9da6-4418-4faf-918c-5807b3b44317	KG	2025-06-15 03:26:37.883854+00	8bd96235-350d-4f6f-9489-3f80122e1c77	Kiloan - Cuci
c59644f9-83cb-4cbe-8dde-7a370a29b16b	PCS	2025-06-15 03:26:37.883854+00	8bd96235-350d-4f6f-9489-3f80122e1c77	Jas
b0a1e8e2-42b0-416e-bcb6-9b5d09fff25e	PCS	2025-06-15 03:26:37.883854+00	8bd96235-350d-4f6f-9489-3f80122e1c77	Boneka
fb5087f3-5683-4000-81d6-9f433ac5f62a	PCS	2025-06-15 03:26:37.883854+00	8bd96235-350d-4f6f-9489-3f80122e1c77	Bedcover
0d5fa21e-d7a1-4226-8148-2c8bf18b8cec	PCS	2025-06-15 03:26:37.883854+00	8bd96235-350d-4f6f-9489-3f80122e1c77	Selimut
2b66b650-2c8e-4811-920f-ab655bd67ee3	KG	2025-06-15 12:21:35.856241+00	eea90897-1470-4ff5-a32d-cabb71375c9e	Kiloan - Cuci, Setrika
b1b93f8e-9ef3-4566-857f-c20f208d1997	KG	2025-06-15 12:21:35.856241+00	eea90897-1470-4ff5-a32d-cabb71375c9e	Kiloan - Cuci
97daf8a4-49e8-47ed-b368-203b2c6fb3b8	PCS	2025-06-15 12:21:35.856241+00	eea90897-1470-4ff5-a32d-cabb71375c9e	Jas
a9ffe775-9ad4-4def-ba00-13329020879f	PCS	2025-06-15 12:21:35.856241+00	eea90897-1470-4ff5-a32d-cabb71375c9e	Boneka
fae3f751-3aa3-4f30-9349-77efd339427f	PCS	2025-06-15 12:21:35.856241+00	eea90897-1470-4ff5-a32d-cabb71375c9e	Bedcover
7dce5d00-03fb-4700-a715-46f994929090	PCS	2025-06-15 12:21:35.856241+00	eea90897-1470-4ff5-a32d-cabb71375c9e	Selimut
891e651e-0e12-4430-b1c3-af212d55d23d	KG	2025-06-15 12:59:20.039467+00	1ad21901-807d-4aa4-80d4-640876d4faab	Kiloan - Cuci, Setrika
3127ebea-6654-4db5-85be-108e2b276142	KG	2025-06-15 12:59:20.039467+00	1ad21901-807d-4aa4-80d4-640876d4faab	Kiloan - Cuci
e45f5b89-89bc-4ac6-b86e-322c30e44d8a	PCS	2025-06-15 12:59:20.039467+00	1ad21901-807d-4aa4-80d4-640876d4faab	Jas
1ae9377c-6951-4098-b234-68dc19d678fd	PCS	2025-06-15 12:59:20.039467+00	1ad21901-807d-4aa4-80d4-640876d4faab	Boneka
7d0144f5-bc0e-4b34-9ba8-2f4fe1b6f078	PCS	2025-06-15 12:59:20.039467+00	1ad21901-807d-4aa4-80d4-640876d4faab	Bedcover
50b72a4d-191b-4e5e-a06e-313b19cc6843	PCS	2025-06-15 12:59:20.039467+00	1ad21901-807d-4aa4-80d4-640876d4faab	Selimut
d545bb1b-ac98-4f13-a72e-5b7b05ed1153	KG	2025-06-15 13:01:09.714034+00	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	Kiloan - Cuci, Setrika
cc91eaa2-b419-44cc-864d-3784b703662c	KG	2025-06-15 13:01:09.714034+00	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	Kiloan - Cuci
364bf1b8-0aac-4f25-bf14-f0332172aba4	PCS	2025-06-15 13:01:09.714034+00	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	Jas
8c113aff-73db-4f3d-8d1c-3828a63ee21b	PCS	2025-06-15 13:01:09.714034+00	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	Boneka
2fe93373-098a-440f-9d39-5ee7916492ad	PCS	2025-06-15 13:01:09.714034+00	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	Bedcover
b4979747-b23c-4ba8-a123-d1753ccc234f	PCS	2025-06-15 13:01:09.714034+00	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	Selimut
b4b8ef64-8fe5-42a2-94f2-99a9435ab757	KG	2025-06-16 14:43:24.217119+00	b54508fb-9003-4919-93e3-096d0b87f9a8	Kiloan - Cuci, Setrika
21d54683-b734-439b-9d68-fe40ebef3444	KG	2025-06-16 14:43:24.217119+00	b54508fb-9003-4919-93e3-096d0b87f9a8	Kiloan - Cuci
93c38c3e-ee57-45c1-b269-534b453d9c71	PCS	2025-06-16 14:43:24.217119+00	b54508fb-9003-4919-93e3-096d0b87f9a8	Jas
a21ac0cb-0b00-4c87-af2d-598de74989f6	PCS	2025-06-16 14:43:24.217119+00	b54508fb-9003-4919-93e3-096d0b87f9a8	Boneka
f68eb99f-9245-45e5-80f6-3f764fa9cada	PCS	2025-06-16 14:43:24.217119+00	b54508fb-9003-4919-93e3-096d0b87f9a8	Bedcover
c0026ce2-18a0-4f06-9e8c-07d124c2fd34	PCS	2025-06-16 14:43:24.217119+00	b54508fb-9003-4919-93e3-096d0b87f9a8	Selimut
b04f1cc6-e2bb-40d8-9325-42928f9dd843	KG	2025-07-07 15:47:09.223472+00	0a78c027-5af9-4360-9ffb-c4b89ada5fdb	Kiloan - Cuci, Setrika
322677a6-24d9-44b5-bae9-7ebe6a97cdc8	KG	2025-07-07 15:47:09.223472+00	0a78c027-5af9-4360-9ffb-c4b89ada5fdb	Kiloan - Cuci
cb183076-c13e-46d5-950f-b40c7e7331b5	PCS	2025-07-07 15:47:09.223472+00	0a78c027-5af9-4360-9ffb-c4b89ada5fdb	Jas
954af9ed-e97e-4f6c-a03f-d47cd9cca4c5	PCS	2025-07-07 15:47:09.223472+00	0a78c027-5af9-4360-9ffb-c4b89ada5fdb	Boneka
507b7670-cc47-414d-9bb5-9fcf58b3e9dc	PCS	2025-07-07 15:47:09.223472+00	0a78c027-5af9-4360-9ffb-c4b89ada5fdb	Bedcover
e43fa975-cf34-4a64-958b-940f88a73227	PCS	2025-07-07 15:47:09.223472+00	0a78c027-5af9-4360-9ffb-c4b89ada5fdb	Selimut
ca92e0e1-d78d-47a2-afab-5d7719fe471a	KG	2025-07-07 15:52:34.649154+00	2003c690-4cf7-46cb-9362-2f6c2d911db7	Kiloan - Cuci, Setrika
6d967eb3-c69b-45ed-9f0d-785eaf478776	KG	2025-07-07 15:52:34.649154+00	2003c690-4cf7-46cb-9362-2f6c2d911db7	Kiloan - Cuci
ef3cefca-6c2c-4dc8-96b8-5751d205cca6	PCS	2025-07-07 15:52:34.649154+00	2003c690-4cf7-46cb-9362-2f6c2d911db7	Jas
f91570c4-ff18-476d-b07c-ff4a863e4241	PCS	2025-07-07 15:52:34.649154+00	2003c690-4cf7-46cb-9362-2f6c2d911db7	Boneka
7e661673-7306-4c22-b723-dec45e620a5e	PCS	2025-07-07 15:52:34.649154+00	2003c690-4cf7-46cb-9362-2f6c2d911db7	Bedcover
3862bc8b-7bbb-4d25-95cf-25964cefcd62	PCS	2025-07-07 15:52:34.649154+00	2003c690-4cf7-46cb-9362-2f6c2d911db7	Selimut
70184a9b-e8a9-4e4b-905a-0aa2b470a4de	KG	2025-07-07 15:53:35.479432+00	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	Kiloan - Cuci, Setrika
ec6450f2-6945-4204-a4fc-75afc2750faf	KG	2025-07-07 15:53:35.479432+00	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	Kiloan - Cuci
9a263a46-ad46-4176-8012-aa43f69ce7d6	PCS	2025-07-07 15:53:35.479432+00	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	Jas
5a7c204c-8d48-414c-90a7-e45d2d3b40a6	PCS	2025-07-07 15:53:35.479432+00	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	Boneka
512178c7-06f0-477c-8f52-adb10b91aa77	PCS	2025-07-07 15:53:35.479432+00	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	Bedcover
5596366b-8d85-42a0-807d-3ac88cdd8fa6	PCS	2025-07-07 15:53:35.479432+00	64c6b8c9-e82c-4b1d-a94c-0a6196edd33e	Selimut
89bd638f-9ddf-48c9-8b64-70ad6a61e7e5	KG	2025-07-07 15:55:46.553254+00	7e214247-26dc-49cc-af5e-48926de89be6	Kiloan - Cuci, Setrika
5eb3b193-a83e-4d89-893e-cb4573accd16	KG	2025-07-07 15:55:46.553254+00	7e214247-26dc-49cc-af5e-48926de89be6	Kiloan - Cuci
6443e4d6-b802-4ce8-92d9-369fcbf1fb8f	PCS	2025-07-07 15:55:46.553254+00	7e214247-26dc-49cc-af5e-48926de89be6	Jas
ccb21722-0e3c-418b-9570-1ade1609022c	PCS	2025-07-07 15:55:46.553254+00	7e214247-26dc-49cc-af5e-48926de89be6	Boneka
c65f66a3-d6ce-446b-8a91-a76f1fc18f0d	PCS	2025-07-07 15:55:46.553254+00	7e214247-26dc-49cc-af5e-48926de89be6	Bedcover
8641d73b-2391-476f-8cb9-f1118fba3745	PCS	2025-07-07 15:55:46.553254+00	7e214247-26dc-49cc-af5e-48926de89be6	Selimut
2ff9f826-8329-456b-bc3e-ac01d15927b3	KG	2025-07-07 15:57:48.951669+00	1c5e12f4-a59a-4838-83cc-bf399f5b9221	Kiloan - Cuci, Setrika
7a567a14-ce52-40e6-8051-0fabfd380292	KG	2025-07-07 15:57:48.951669+00	1c5e12f4-a59a-4838-83cc-bf399f5b9221	Kiloan - Cuci
2b47a857-0b5e-462c-8f8e-a4f5d3f3f497	PCS	2025-07-07 15:57:48.951669+00	1c5e12f4-a59a-4838-83cc-bf399f5b9221	Jas
956913d4-f543-4e2d-b08a-a7cf2e56c124	PCS	2025-07-07 15:57:48.951669+00	1c5e12f4-a59a-4838-83cc-bf399f5b9221	Boneka
f0721182-ab7e-4834-90e4-d8a3114244bc	PCS	2025-07-07 15:57:48.951669+00	1c5e12f4-a59a-4838-83cc-bf399f5b9221	Bedcover
a123c696-294c-433f-ad52-3b60ddbac1b1	PCS	2025-07-07 15:57:48.951669+00	1c5e12f4-a59a-4838-83cc-bf399f5b9221	Selimut
15ac6a8c-a5e1-4cb1-95ff-cea105ee7c32	KG	2025-07-07 16:03:08.483403+00	a7d92f73-5755-49a1-971c-5e14c1d47a31	Kiloan - Cuci, Setrika
07bc69c7-9b1d-42bf-9ccd-b25968fd97df	KG	2025-07-07 16:03:08.483403+00	a7d92f73-5755-49a1-971c-5e14c1d47a31	Kiloan - Cuci
24e0f7bd-6c7f-4ab4-93e6-1e2c4f56cf92	PCS	2025-07-07 16:03:08.483403+00	a7d92f73-5755-49a1-971c-5e14c1d47a31	Jas
e8378f27-4529-4ab4-a5cd-33bb70112fae	PCS	2025-07-07 16:03:08.483403+00	a7d92f73-5755-49a1-971c-5e14c1d47a31	Boneka
80fecff3-0bbc-45e4-a801-8c0ab99556af	PCS	2025-07-07 16:03:08.483403+00	a7d92f73-5755-49a1-971c-5e14c1d47a31	Bedcover
45ddc269-c50c-464a-8fe4-56dcd2b5ced2	PCS	2025-07-07 16:03:08.483403+00	a7d92f73-5755-49a1-971c-5e14c1d47a31	Selimut
be7085a5-b52b-4544-b3b2-4e306e8223c7	KG	2025-07-12 05:40:22.296645+00	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	Kiloan - Cuci, Setrika
d95ccefa-a340-4319-a150-11898b9f7d8f	KG	2025-07-12 05:40:22.296645+00	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	Kiloan - Cuci
8e1225c5-f1f3-4adb-87d5-316321c48730	PCS	2025-07-12 05:40:22.296645+00	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	Jas
d6b2a483-4c8e-4471-a044-225fccbac7d1	PCS	2025-07-12 05:40:22.296645+00	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	Boneka
8c9dd674-bd3c-4a1c-8427-6774876c9a73	PCS	2025-07-12 05:40:22.296645+00	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	Bedcover
5ded865e-2b00-46bb-b9c4-0cd9f53e3a8b	PCS	2025-07-12 05:40:22.296645+00	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	Selimut
7229c439-d63f-42bb-b943-e62cd7afe08f	KG	2025-07-12 05:52:39.653711+00	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	Kiloan - Cuci, Setrika
e15293ca-ccf2-42b1-a9c8-319787f08c18	KG	2025-07-12 05:52:39.653711+00	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	Kiloan - Cuci
9596a69f-d713-4e24-becf-15236e81182f	PCS	2025-07-12 05:52:39.653711+00	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	Jas
fff35020-b4de-4963-825a-cf47c4ec260a	PCS	2025-07-12 05:52:39.653711+00	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	Boneka
2f3a52e7-3c9e-4b2d-a7bf-ebe9a71e606f	PCS	2025-07-12 05:52:39.653711+00	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	Bedcover
636b718d-d5fc-4e6c-beb9-b6bf1572cb13	PCS	2025-07-12 05:52:39.653711+00	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	Selimut
f18d148b-88ca-48d4-ab19-ae6398bb677e	KG	2025-07-12 06:03:31.332654+00	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	Kiloan - Cuci, Setrika
dd5f20e5-c3ba-4195-ab36-1af339117271	KG	2025-07-12 06:03:31.332654+00	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	Kiloan - Cuci
5988cbdb-0653-4f17-b68c-d6f8332e4c8d	PCS	2025-07-12 06:03:31.332654+00	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	Jas
49f4fb06-01d3-406d-8ae0-159bb708dae3	PCS	2025-07-12 06:03:31.332654+00	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	Boneka
18862fc4-21e3-4e98-83a3-0b853da64821	PCS	2025-07-12 06:03:31.332654+00	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	Bedcover
5f9e5907-4abc-452b-95b9-5ff87739661c	PCS	2025-07-12 06:03:31.332654+00	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	Selimut
8d93401f-557b-42c3-815d-f288a53a4efb	KG	2025-07-13 07:23:38.406043+00	18184643-ccb7-4f42-aa82-d423445bcf3d	Kiloan - Cuci, Setrika
c26eeeef-e2a9-4f91-a37b-6c0cff91fdd8	KG	2025-07-13 07:23:38.406043+00	18184643-ccb7-4f42-aa82-d423445bcf3d	Kiloan - Cuci
ed9cd473-3609-4692-a2b3-b96c6a5ff2e5	PCS	2025-07-13 07:23:38.406043+00	18184643-ccb7-4f42-aa82-d423445bcf3d	Jas
5159a91c-dece-4077-95e9-3ddfc21eaa22	PCS	2025-07-13 07:23:38.406043+00	18184643-ccb7-4f42-aa82-d423445bcf3d	Boneka
5069bdd5-e72d-491f-8077-d49d51ff6a79	PCS	2025-07-13 07:23:38.406043+00	18184643-ccb7-4f42-aa82-d423445bcf3d	Bedcover
3a2337ca-7113-4ff1-ba8a-a702b7c5d986	PCS	2025-07-13 07:23:38.406043+00	18184643-ccb7-4f42-aa82-d423445bcf3d	Selimut
7171dc14-31d7-43a1-b8bc-854f8a230523	KG	2025-07-20 03:20:17.020718+00	e128e7f5-d6b1-4895-98d0-84583540da63	Kiloan - Cuci, Setrika
4ab071cd-16b7-4b9b-a8b7-52871fbddd4e	KG	2025-07-20 03:20:17.020718+00	e128e7f5-d6b1-4895-98d0-84583540da63	Kiloan - Cuci
3187c4e4-608d-4a5b-8fd8-758bbb9f6401	PCS	2025-07-20 03:20:17.020718+00	e128e7f5-d6b1-4895-98d0-84583540da63	Jas
664f758c-ef78-45ef-9909-700f6dd39837	PCS	2025-07-20 03:20:17.020718+00	e128e7f5-d6b1-4895-98d0-84583540da63	Boneka
513ab6c5-e84f-463f-ae29-56fb3643c2f4	PCS	2025-07-20 03:20:17.020718+00	e128e7f5-d6b1-4895-98d0-84583540da63	Bedcover
868a510c-67ff-4762-ad46-c871bf6d125c	PCS	2025-07-20 03:20:17.020718+00	e128e7f5-d6b1-4895-98d0-84583540da63	Selimut
44c3dc59-1a9e-4889-a6bf-a2b9e23e0c73	KG	2025-07-20 03:27:11.149442+00	7728b222-a096-4da0-96af-0b7934f8b9ba	Kiloan - Cuci, Setrika
e41af5f6-32e8-412b-a8c0-6e2ff602e61b	KG	2025-07-20 03:27:11.149442+00	7728b222-a096-4da0-96af-0b7934f8b9ba	Kiloan - Cuci
fc0a9f5e-ad8c-442e-b5f8-420cd4d49910	PCS	2025-07-20 03:27:11.149442+00	7728b222-a096-4da0-96af-0b7934f8b9ba	Jas
729e0b7c-e911-4575-8548-cb37dae3b318	PCS	2025-07-20 03:27:11.149442+00	7728b222-a096-4da0-96af-0b7934f8b9ba	Boneka
c603c6d5-68eb-4dbf-b74b-70b7ee5d77c2	PCS	2025-07-20 03:27:11.149442+00	7728b222-a096-4da0-96af-0b7934f8b9ba	Bedcover
f0cc027a-17a8-48a0-9235-7ae4daf0d37b	PCS	2025-07-20 03:27:11.149442+00	7728b222-a096-4da0-96af-0b7934f8b9ba	Selimut
f1e65129-aed7-4138-8a82-d3e5024be7ca	KG	2025-08-05 14:27:20.893026+00	d9453749-87fb-469d-a93a-22a577b0e98b	Kiloan - Cuci, Setrika
5e8ca89d-1c8f-45cf-89bd-2f0335719241	KG	2025-08-05 14:27:20.893026+00	d9453749-87fb-469d-a93a-22a577b0e98b	Kiloan - Cuci
1eb79a3a-a6b1-4f6b-aec2-33a11517d7bb	PCS	2025-08-05 14:27:20.893026+00	d9453749-87fb-469d-a93a-22a577b0e98b	Jas
d59c4fd7-b65b-41ff-9796-b74a79eb3b89	PCS	2025-08-05 14:27:20.893026+00	d9453749-87fb-469d-a93a-22a577b0e98b	Boneka
c5f8dec4-f68b-4a54-bcaf-42029ff74bdf	PCS	2025-08-05 14:27:20.893026+00	d9453749-87fb-469d-a93a-22a577b0e98b	Bedcover
0c333200-7b95-488e-bbf3-c2de8be99d4a	PCS	2025-08-05 14:27:20.893026+00	d9453749-87fb-469d-a93a-22a577b0e98b	Selimut
d34e80d8-b9c2-4d37-8062-1ca691fdf0fa	KG	2025-08-12 13:48:13.33748+00	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Kiloan - Cuci, Setrika
03ff0039-f996-4e4d-823b-d7119b207112	KG	2025-08-12 13:48:13.33748+00	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Kiloan - Cuci
ab751b68-fa70-4a53-8fa3-20e7207197f4	PCS	2025-08-12 13:48:13.33748+00	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Jas
59990330-110a-4196-86ca-35809748d639	PCS	2025-08-12 13:48:13.33748+00	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Boneka
f6c33e9f-763c-4372-acc5-5b5fc72897ba	PCS	2025-08-12 13:48:13.33748+00	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Bedcover
b502a20e-1f73-4c29-8d1d-5ad947a0627e	PCS	2025-08-12 13:48:13.33748+00	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Selimut
2520b782-8dae-4ab6-b21a-41b53b881dd1	KG	2025-08-26 13:33:51.993261+00	fe4e3388-40d9-422a-8140-a5a21ab56fbb	Kiloan - Cuci, Setrika
48d06cec-d463-42b1-a0b0-73acb75b80ed	KG	2025-08-26 13:33:51.993261+00	fe4e3388-40d9-422a-8140-a5a21ab56fbb	Kiloan - Cuci
2253837f-605a-4b8d-97ed-f16f6018a874	PCS	2025-09-09 15:02:17.017864+00	7aefc064-bbad-40cc-b31e-645c90c9116c	Bedcover
bf83182b-2802-478a-bd5b-12cda1ef888d	PCS	2025-09-09 15:02:17.017864+00	7aefc064-bbad-40cc-b31e-645c90c9116c	Selimut
4cf89487-df3a-46e9-a239-ceb2d13b2408	KG	2025-09-09 15:02:17.017864+00	7aefc064-bbad-40cc-b31e-645c90c9116c	Kiloan - Cuci, Setrika
3950254c-8f5d-4e88-817e-14c7d2dcac2a	KG	2025-09-23 12:04:44.747711+00	8db3f967-5f09-4150-a95b-010faa31a22a	Kiloan - Cuci
6881c6eb-7f7b-4bce-91cc-f94036d5e8a5	uu	2025-11-29 11:45:08.013274+00	8db3f967-5f09-4150-a95b-010faa31a22a	yyy
1e7e09da-50e8-4627-85ea-2edc6c6d9616	KG	2025-09-23 12:04:44.747711+00	8db3f967-5f09-4150-a95b-010faa31a22a	Kiloan - Cuci, Setrika rr
4366e0da-b079-4d0c-82a9-49a3e3a15280	KG	2025-12-24 11:58:58.634635+00	acb4da41-865e-40d9-a330-070c0a2b88c8	Kiloan - Cuci, Setrika
3b9f30ac-64d8-4941-aff6-79cec285fa06	kg	2025-09-10 14:32:44.634731+00	7aefc064-bbad-40cc-b31e-645c90c9116c	test2
1c09d04f-3b07-40b3-9ef1-af3546b692e2	ipul	2025-09-12 13:23:48.602258+00	7aefc064-bbad-40cc-b31e-645c90c9116c	test
da33acb6-03be-4ae1-aede-8ff5f4309e95	KG	2025-09-23 00:42:12.596764+00	f048badd-8538-46fe-bd12-ddfaa30646b2	Kiloan - Cuci, Setrika
3e1c5c35-b7fc-49ae-ac4a-c5c9098a915f	KG	2025-09-23 00:42:12.596764+00	f048badd-8538-46fe-bd12-ddfaa30646b2	Kiloan - Cuci
3d39897b-c053-429a-918c-6d222191b514	PCS	2025-09-23 00:42:12.596764+00	f048badd-8538-46fe-bd12-ddfaa30646b2	Jas
de535e44-abc0-4b0b-8384-4e7289c5c090	PCS	2025-09-23 00:42:12.596764+00	f048badd-8538-46fe-bd12-ddfaa30646b2	Boneka
28e78b06-273a-4cb9-8cd2-1b69f7ef7633	PCS	2025-09-23 00:42:12.596764+00	f048badd-8538-46fe-bd12-ddfaa30646b2	Bedcover
82fd5297-f241-475d-b5ca-e394ec135b20	PCS	2025-09-23 00:42:12.596764+00	f048badd-8538-46fe-bd12-ddfaa30646b2	Selimut
34efee85-0e62-4bee-bbc1-3257cadf4c49	PCS	2025-09-23 12:04:44.747711+00	8db3f967-5f09-4150-a95b-010faa31a22a	Boneka
f53e3edd-c4aa-433c-a122-af1ac430ccaf	PCS	2025-09-23 12:04:44.747711+00	8db3f967-5f09-4150-a95b-010faa31a22a	Bedcover
76e0950f-1dd1-4fd3-a2de-230993cf3c23	KG	2025-11-10 12:03:00.974657+00	9e9f89b7-0659-411f-b06d-d75bff0eb648	Kiloan - Cuci, Setrika
d9ffb40c-fa90-4f90-a01a-2fcbaa9751de	KG	2025-11-10 12:03:00.974657+00	9e9f89b7-0659-411f-b06d-d75bff0eb648	Kiloan - Cuci
aa07aa06-7c52-46d6-93e6-507682d16ad3	PCS	2025-11-10 12:03:00.974657+00	9e9f89b7-0659-411f-b06d-d75bff0eb648	Jas
2f2da3ca-d98d-44bc-98e1-2f9258722ef3	PCS	2025-11-10 12:03:00.974657+00	9e9f89b7-0659-411f-b06d-d75bff0eb648	Boneka
a4e8d788-d5ea-4ddf-8695-8060d0e2d31a	PCS	2025-11-10 12:03:00.974657+00	9e9f89b7-0659-411f-b06d-d75bff0eb648	Bedcover
e4928f6f-7a14-4446-a2eb-cf5322e8d554	PCS	2025-11-10 12:03:00.974657+00	9e9f89b7-0659-411f-b06d-d75bff0eb648	Selimut
327bb7d7-12d5-425b-a22f-d64a1e5265c1	KG	2025-11-10 12:08:21.837634+00	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	Kiloan - Cuci, Setrika
63d38926-3f13-48d8-a1a8-493e1c455dbd	KG	2025-11-10 12:08:21.837634+00	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	Kiloan - Cuci
a9b1cc8a-8b93-4c5c-aa03-d7b8cb0c3bdc	PCS	2025-11-10 12:08:21.837634+00	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	Jas
65cfeee7-ea87-48b0-9447-e5f0ae046fc0	PCS	2025-11-10 12:08:21.837634+00	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	Boneka
2f695346-932c-4ef2-816e-e1b3b1e99b7a	PCS	2025-11-10 12:08:21.837634+00	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	Bedcover
f2407bed-c06e-4e4d-b5e7-bafa7943d188	PCS	2025-11-10 12:08:21.837634+00	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	Selimut
6bc12792-f762-443e-9d01-e8750993ee0e	KG	2025-11-10 14:31:44.007636+00	83731f63-30af-4793-be22-43d9b622e7d4	Kiloan - Cuci, Setrika
c5a2994a-4aa7-4bc1-b0ee-bb687540f79e	KG	2025-11-10 14:31:44.007636+00	83731f63-30af-4793-be22-43d9b622e7d4	Kiloan - Cuci
d49c620e-fb1a-4a8f-99bc-180666ae6220	PCS	2025-11-10 14:31:44.007636+00	83731f63-30af-4793-be22-43d9b622e7d4	Jas
fefdd5ca-8866-4dab-9309-84bf505ef511	PCS	2025-11-10 14:31:44.007636+00	83731f63-30af-4793-be22-43d9b622e7d4	Boneka
af647ebb-320a-421f-b224-3a5589e06f4d	PCS	2025-11-10 14:31:44.007636+00	83731f63-30af-4793-be22-43d9b622e7d4	Bedcover
578eae9d-c6e6-43b9-9fb3-011ff02129ae	PCS	2025-11-10 14:31:44.007636+00	83731f63-30af-4793-be22-43d9b622e7d4	Selimut
bcbb862a-6c07-4230-b9f0-2640100d06af	KG	2025-12-24 11:58:58.634635+00	acb4da41-865e-40d9-a330-070c0a2b88c8	Kiloan - Cuci
0b7842b4-140e-4c87-b609-c641d244e9a2	KG	2025-11-12 23:20:09.904204+00	6fed4540-3689-4ee4-837d-614174568f7d	Kiloan - Cuci, Setrika
e7a3e1bf-522f-44e5-8518-bacc1587c0ab	KG	2025-11-12 23:20:09.904204+00	6fed4540-3689-4ee4-837d-614174568f7d	Kiloan - Cuci
db7169e3-e443-4c74-9698-23ac71a5f9f0	PCS	2025-11-12 23:20:09.904204+00	6fed4540-3689-4ee4-837d-614174568f7d	Jas
01bba5e7-6a65-4ec2-927c-383be520c01c	PCS	2025-11-12 23:20:09.904204+00	6fed4540-3689-4ee4-837d-614174568f7d	Boneka
3a388245-4956-4f89-a399-8a9004003380	PCS	2025-11-12 23:20:09.904204+00	6fed4540-3689-4ee4-837d-614174568f7d	Bedcover
b8c56f1e-928a-4e8f-a890-23fd957b1801	PCS	2025-11-12 23:20:09.904204+00	6fed4540-3689-4ee4-837d-614174568f7d	Selimut
da628915-bf54-4ee6-a889-7ee4d47968ff	PCS	2025-12-24 11:58:58.634635+00	acb4da41-865e-40d9-a330-070c0a2b88c8	Jas
56ef1d13-edf2-4eaa-8c64-e551f9603865	PCS	2025-12-24 11:58:58.634635+00	acb4da41-865e-40d9-a330-070c0a2b88c8	Boneka
264537bc-7c2d-4508-b270-9b1297d3d780	PCS	2025-12-24 11:58:58.634635+00	acb4da41-865e-40d9-a330-070c0a2b88c8	Bedcover
37909974-750d-44fb-8054-201b47aa1313	PCS	2025-12-24 11:58:58.634635+00	acb4da41-865e-40d9-a330-070c0a2b88c8	Selimut
f802a4ac-ce12-4397-9f58-e2e894af093a	KG	2025-12-24 12:05:47.624747+00	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	Kiloan - Cuci, Setrika
973dff2a-3c4c-4689-8380-a61626aeb325	KG	2025-12-24 12:05:47.624747+00	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	Kiloan - Cuci
5077a326-07d2-4077-852e-794689eeefa7	PCS	2025-12-24 12:05:47.624747+00	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	Jas
372efe29-88dd-4205-8147-a25c13e8aa26	PCS	2025-12-24 12:05:47.624747+00	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	Boneka
c0b0e1d6-2c84-4113-9902-a49b68dd99c2	PCS	2025-12-24 12:05:47.624747+00	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	Bedcover
45508d99-9adb-4a00-bcc2-5a400b869bd3	PCS	2025-12-24 12:05:47.624747+00	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	Selimut
601ef8e1-9b64-4c3c-ada6-09b1aa37478b	KG	2025-12-24 12:09:41.331645+00	dd479ee9-79bd-4642-b46a-d87f97446a78	Kiloan - Cuci, Setrika
35dbabfb-9967-461e-90f1-7b4152d14d40	KG	2025-12-24 12:09:41.331645+00	dd479ee9-79bd-4642-b46a-d87f97446a78	Kiloan - Cuci
11a96658-4255-4fa4-84ec-747b390a0eda	PCS	2025-12-24 12:09:41.331645+00	dd479ee9-79bd-4642-b46a-d87f97446a78	Jas
bb9dd608-475d-4bf4-abf8-794559d73f0e	PCS	2025-12-24 12:09:41.331645+00	dd479ee9-79bd-4642-b46a-d87f97446a78	Boneka
ade6dba0-5dee-4ef1-88ff-39e42a91696a	PCS	2025-12-24 12:09:41.331645+00	dd479ee9-79bd-4642-b46a-d87f97446a78	Bedcover
551b01f6-3065-447f-93cf-4f07b9c63282	PCS	2025-12-24 12:09:41.331645+00	dd479ee9-79bd-4642-b46a-d87f97446a78	Selimut
bb26cd46-d1d0-4ddc-a182-05aa3bd76d0a	KG	2025-12-24 12:15:35.563358+00	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	Kiloan - Cuci, Setrika
736b116e-217e-4b6a-9af5-2a9b5df90ff6	KG	2025-12-24 12:15:35.563358+00	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	Kiloan - Cuci
42230aeb-f872-47cb-b1a8-ca4778a13556	PCS	2025-12-24 12:15:35.563358+00	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	Jas
b16ccfac-2b09-45f0-85c5-fdd1a8b67b4e	PCS	2025-12-24 12:15:35.563358+00	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	Boneka
68228ad3-8ea1-45f8-8a53-cc12c3fb2b85	PCS	2025-12-24 12:15:35.563358+00	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	Bedcover
b203a6ce-beaa-49cf-81ef-ee462b6798f4	PCS	2025-12-24 12:15:35.563358+00	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	Selimut
23e40e3e-12a5-4b5d-9ca2-220c7a0d6c1f	KG	2025-12-26 02:01:09.782052+00	20a1b60b-2c45-4533-a02e-ad9d4545b860	Kiloan - Cuci, Setrika
94c29859-f311-47fc-985f-02877314c94d	KG	2025-12-26 02:01:09.782052+00	20a1b60b-2c45-4533-a02e-ad9d4545b860	Kiloan - Cuci
4bc50d6e-d0e5-41e1-bb69-23153e88841a	PCS	2025-12-26 02:01:09.782052+00	20a1b60b-2c45-4533-a02e-ad9d4545b860	Jas
13bc9474-3d55-484a-958f-9c772b895bc8	PCS	2025-12-26 02:01:09.782052+00	20a1b60b-2c45-4533-a02e-ad9d4545b860	Boneka
aaacfbdc-e890-40cf-af7e-15dfd8affed6	PCS	2025-12-26 02:01:09.782052+00	20a1b60b-2c45-4533-a02e-ad9d4545b860	Bedcover
b0834ee9-5999-443e-bfbb-145cf521e9f8	PCS	2025-12-26 02:01:09.782052+00	20a1b60b-2c45-4533-a02e-ad9d4545b860	Selimut
98f635c7-7973-45e9-b643-980156f7ec7c	KG	2025-12-26 02:08:36.207421+00	3d57f37f-755f-42b5-a3a4-9de23314881a	Kiloan - Cuci, Setrika
efbd7e18-5d8c-4431-acb2-08a3ef5ae467	KG	2025-12-26 02:08:36.207421+00	3d57f37f-755f-42b5-a3a4-9de23314881a	Kiloan - Cuci
16af5fee-10c8-4788-99a5-410593e22116	PCS	2025-12-26 02:08:36.207421+00	3d57f37f-755f-42b5-a3a4-9de23314881a	Jas
7b5f80b7-6ed2-43a7-b622-8d4f35557686	PCS	2025-12-26 02:08:36.207421+00	3d57f37f-755f-42b5-a3a4-9de23314881a	Boneka
9fa58609-404b-4ac0-a23f-6f136cf5da82	PCS	2025-12-26 02:08:36.207421+00	3d57f37f-755f-42b5-a3a4-9de23314881a	Bedcover
f6ae74ac-32bd-40dd-a91f-c839684c5074	PCS	2025-12-26 02:08:36.207421+00	3d57f37f-755f-42b5-a3a4-9de23314881a	Selimut
48bd244b-05c5-471f-8d62-873cef0f4ead	KG	2025-12-26 02:09:09.744311+00	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	Kiloan - Cuci, Setrika
dac5402d-98b2-4d69-927e-1943baf75f07	KG	2025-12-26 02:09:09.744311+00	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	Kiloan - Cuci
049a7886-8a79-49ad-911e-e8651a116689	PCS	2025-12-26 02:09:09.744311+00	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	Jas
5f71d04a-5d80-4fc0-8eee-eccd74f631af	PCS	2025-12-26 02:09:09.744311+00	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	Boneka
a58a3658-e442-4ec4-a624-cdb624f5fb95	PCS	2025-12-26 02:09:09.744311+00	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	Bedcover
0798b241-f35e-401d-a2e0-a1941539a66f	PCS	2025-12-26 02:09:09.744311+00	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	Selimut
2ce6b302-43f0-4fb8-9ca3-93a0cc06e7b9	KG	2025-12-29 13:47:33.752859+00	40b66b3d-ca74-414c-8879-3318ab49ce38	Kiloan - Cuci, Setrika
5634dd10-dae5-4c59-8fab-aeab90926e0a	KG	2025-12-29 13:47:33.752859+00	40b66b3d-ca74-414c-8879-3318ab49ce38	Kiloan - Cuci
95dffe87-7bdb-4ba6-9b17-ab2f28ba986c	PCS	2025-12-29 13:47:33.752859+00	40b66b3d-ca74-414c-8879-3318ab49ce38	Jas
7600ed94-89a0-4610-8568-293567df299f	PCS	2025-12-29 13:47:33.752859+00	40b66b3d-ca74-414c-8879-3318ab49ce38	Boneka
68f69f29-8bca-4773-a74f-dca264f67796	PCS	2025-12-29 13:47:33.752859+00	40b66b3d-ca74-414c-8879-3318ab49ce38	Bedcover
51129e3b-bc57-4830-8884-cb365400f7cf	PCS	2025-12-29 13:47:33.752859+00	40b66b3d-ca74-414c-8879-3318ab49ce38	Selimut
42d46274-b70c-4f5d-a4c6-5ee8360d1a86	KG	2025-12-29 13:56:31.2994+00	d74b18af-dd09-42f1-97c6-1286fb33604c	Kiloan - Cuci, Setrika
39e39e3e-6627-4064-afdc-f297eb94542d	KG	2025-12-29 13:56:31.2994+00	d74b18af-dd09-42f1-97c6-1286fb33604c	Kiloan - Cuci
b4fc1633-fe39-4013-9145-34fe30b9a3ca	PCS	2025-12-29 13:56:31.2994+00	d74b18af-dd09-42f1-97c6-1286fb33604c	Jas
92c55d81-8cb1-4730-b9a8-dd04bfbaf7d7	PCS	2025-12-29 13:56:31.2994+00	d74b18af-dd09-42f1-97c6-1286fb33604c	Boneka
6be12983-16f9-48d3-99fc-7d9c775af80f	PCS	2025-12-29 13:56:31.2994+00	d74b18af-dd09-42f1-97c6-1286fb33604c	Bedcover
bc282bc7-e577-4e97-9fa4-5d5b43f37bdf	PCS	2025-12-29 13:56:31.2994+00	d74b18af-dd09-42f1-97c6-1286fb33604c	Selimut
c6dd7400-8c3d-4dda-9327-97223f4c99b1	KG	2025-12-29 14:01:00.127012+00	9673cd3f-9374-4ecc-a569-d750f3f3ff34	Kiloan - Cuci, Setrika
4190e027-ede3-4f33-8a52-cc8182dc149e	KG	2025-12-29 14:01:00.127012+00	9673cd3f-9374-4ecc-a569-d750f3f3ff34	Kiloan - Cuci
374ffadf-363a-4898-94a1-c57f94ca9358	PCS	2025-12-29 14:01:00.127012+00	9673cd3f-9374-4ecc-a569-d750f3f3ff34	Jas
3d5f3555-1146-4ce1-87dd-e1f7e8ef8dfd	PCS	2025-12-29 14:01:00.127012+00	9673cd3f-9374-4ecc-a569-d750f3f3ff34	Boneka
2376346c-b674-4910-8415-69bba60dd821	PCS	2025-12-29 14:01:00.127012+00	9673cd3f-9374-4ecc-a569-d750f3f3ff34	Bedcover
424893ff-b48a-4a3b-a0ff-cb67e5241a89	PCS	2025-12-29 14:01:00.127012+00	9673cd3f-9374-4ecc-a569-d750f3f3ff34	Selimut
4557bb24-b8cc-4558-b502-00a4ebfa8e6a	KG	2025-12-29 14:02:53.837645+00	ba472db5-f09a-48c3-b6c9-e3233acfc46f	Kiloan - Cuci, Setrika
8f1cdf48-5638-4fc6-8a56-0456533b17ec	KG	2025-12-29 14:02:53.837645+00	ba472db5-f09a-48c3-b6c9-e3233acfc46f	Kiloan - Cuci
7b886772-a94b-4234-89b9-c7ed06bebc3a	PCS	2025-12-29 14:02:53.837645+00	ba472db5-f09a-48c3-b6c9-e3233acfc46f	Jas
9aebc110-8f3b-4240-9608-e8bcef35ca3f	PCS	2025-12-29 14:02:53.837645+00	ba472db5-f09a-48c3-b6c9-e3233acfc46f	Boneka
fa268402-6546-4f30-90aa-e1f943c5fc12	PCS	2025-12-29 14:02:53.837645+00	ba472db5-f09a-48c3-b6c9-e3233acfc46f	Bedcover
01b50669-527e-45bb-865f-08427b48e7f8	PCS	2025-12-29 14:02:53.837645+00	ba472db5-f09a-48c3-b6c9-e3233acfc46f	Selimut
e186215f-2464-4584-980e-36ec5ebe0285	KG	2025-12-29 14:04:59.02137+00	3d54010f-5655-4c05-bed1-4984d5347c93	Kiloan - Cuci, Setrika
206f74d7-d74d-4066-8cb9-5e22e8705017	KG	2025-12-29 14:04:59.02137+00	3d54010f-5655-4c05-bed1-4984d5347c93	Kiloan - Cuci
cb681add-b95a-463f-9315-ab6bf98b3645	PCS	2025-12-29 14:04:59.02137+00	3d54010f-5655-4c05-bed1-4984d5347c93	Jas
0c4ac855-502f-47b3-9142-d8eb6bc38f4f	PCS	2025-12-29 14:04:59.02137+00	3d54010f-5655-4c05-bed1-4984d5347c93	Boneka
e1fb49d3-b6fd-43c7-b2fd-45fc6a6300a4	PCS	2025-12-29 14:04:59.02137+00	3d54010f-5655-4c05-bed1-4984d5347c93	Bedcover
2f6eb472-ed2b-4034-9205-44cebc090a97	PCS	2025-12-29 14:04:59.02137+00	3d54010f-5655-4c05-bed1-4984d5347c93	Selimut
0a21ddea-5b70-4b81-9993-39d5edff4327	KG	2026-02-21 07:39:47.200396+00	6e56ab91-182b-4f44-b226-d1f0dc289423	Kiloan - Cuci, Setrika
0d35a926-2327-40d8-bc28-6ed427c54eda	KG	2026-02-21 07:39:47.200396+00	6e56ab91-182b-4f44-b226-d1f0dc289423	Kiloan - Cuci
4f588eab-510c-4e93-aa51-2f80029f5f99	PCS	2026-02-21 07:39:47.200396+00	6e56ab91-182b-4f44-b226-d1f0dc289423	Jas
0478b2cd-187a-4931-9cda-c9d66ead2162	PCS	2026-02-21 07:39:47.200396+00	6e56ab91-182b-4f44-b226-d1f0dc289423	Boneka
d8ea9db0-204e-4d55-a402-f14c0bae94eb	PCS	2026-02-21 07:39:47.200396+00	6e56ab91-182b-4f44-b226-d1f0dc289423	Bedcover
da8e65b0-2e18-43dc-8e34-b2e6ab1215ea	PCS	2026-02-21 07:39:47.200396+00	6e56ab91-182b-4f44-b226-d1f0dc289423	Selimut
f23f59b2-25bf-43f2-9bfa-f483dbfbf1de	KG	2026-02-21 07:40:46.243271+00	579c0264-e4bf-4cac-881d-2d3aa5fff59d	Kiloan - Cuci, Setrika
6ac26169-078e-41a3-b6f2-bb428678c97c	KG	2026-02-21 07:40:46.243271+00	579c0264-e4bf-4cac-881d-2d3aa5fff59d	Kiloan - Cuci
5309f142-929c-4fe3-8404-1e5413d3210d	PCS	2026-02-21 07:40:46.243271+00	579c0264-e4bf-4cac-881d-2d3aa5fff59d	Jas
a0f1fb0d-06ea-4fb9-b7cd-59e2a95997a0	PCS	2026-02-21 07:40:46.243271+00	579c0264-e4bf-4cac-881d-2d3aa5fff59d	Boneka
0265da5f-7294-4feb-a951-d5e23d352f57	PCS	2026-02-21 07:40:46.243271+00	579c0264-e4bf-4cac-881d-2d3aa5fff59d	Bedcover
28bd00f7-b0aa-490c-ab9d-11515cf8104d	PCS	2026-02-21 07:40:46.243271+00	579c0264-e4bf-4cac-881d-2d3aa5fff59d	Selimut
d127049b-14b8-4434-b01d-118818a8d59e	KG	2026-02-21 07:41:12.842216+00	8d468ffc-f533-48ba-8c6b-285d63647a99	Kiloan - Cuci, Setrika
1d338adc-9887-4bb3-9575-2efbeb690343	KG	2026-02-21 07:41:12.842216+00	8d468ffc-f533-48ba-8c6b-285d63647a99	Kiloan - Cuci
b3751879-3a47-4c55-85b3-fd99778ab133	PCS	2026-02-21 07:41:12.842216+00	8d468ffc-f533-48ba-8c6b-285d63647a99	Jas
4059fbec-6a42-4b78-b03c-7f06d541ffb5	PCS	2026-02-21 07:41:12.842216+00	8d468ffc-f533-48ba-8c6b-285d63647a99	Boneka
397cd58f-cc3f-4975-9172-61e9b92a54b8	PCS	2026-02-21 07:41:12.842216+00	8d468ffc-f533-48ba-8c6b-285d63647a99	Bedcover
b54b506a-2bdb-4af1-9750-f53c00d6b417	PCS	2026-02-21 07:41:12.842216+00	8d468ffc-f533-48ba-8c6b-285d63647a99	Selimut
77c5e880-423f-4f2a-af97-36bc9902b934	KG	2026-02-21 07:41:28.499124+00	65e7caf4-1316-49da-a3b9-3b7f8fef3955	Kiloan - Cuci, Setrika
68bbafc7-3045-4326-886a-406532847e9b	KG	2026-02-21 07:41:28.499124+00	65e7caf4-1316-49da-a3b9-3b7f8fef3955	Kiloan - Cuci
7e7b8dbc-fc61-4c20-a34c-a8df21f9d2b2	PCS	2026-02-21 07:41:28.499124+00	65e7caf4-1316-49da-a3b9-3b7f8fef3955	Jas
a73b5fab-4dfa-485c-8cb6-c1c3f7a714bc	PCS	2026-02-21 07:41:28.499124+00	65e7caf4-1316-49da-a3b9-3b7f8fef3955	Boneka
89897de9-347f-40b5-8623-0e06ec7d05d7	PCS	2026-02-21 07:41:28.499124+00	65e7caf4-1316-49da-a3b9-3b7f8fef3955	Bedcover
5993cd2a-3f27-4e9c-b9cb-a6094ea53095	PCS	2026-02-21 07:41:28.499124+00	65e7caf4-1316-49da-a3b9-3b7f8fef3955	Selimut
4af2b638-8c6c-4a20-9340-d9be3bffa6e9	KG	2026-02-22 12:46:24.072509+00	cf7cfef7-6850-46c2-9efc-22c28cb0922c	Kiloan - Cuci, Setrika
ca1053f7-2c33-407b-b4db-31843d37d59e	KG	2026-02-22 12:46:24.072509+00	cf7cfef7-6850-46c2-9efc-22c28cb0922c	Kiloan - Cuci
c8f58f97-2ad0-4123-8859-ff2c8bbd0912	PCS	2026-02-22 12:46:24.072509+00	cf7cfef7-6850-46c2-9efc-22c28cb0922c	Jas
718520bf-40cf-4e9e-8b5a-9e2ca5bb9231	PCS	2026-02-22 12:46:24.072509+00	cf7cfef7-6850-46c2-9efc-22c28cb0922c	Boneka
1f5a9647-72ec-4a15-a464-489e935318e6	PCS	2026-02-22 12:46:24.072509+00	cf7cfef7-6850-46c2-9efc-22c28cb0922c	Bedcover
9a3df121-8c9c-4661-ae1a-340cb170f621	PCS	2026-02-22 12:46:24.072509+00	cf7cfef7-6850-46c2-9efc-22c28cb0922c	Selimut
ea54276c-3bb3-4c7e-9dc8-8250222d8cf0	KG	2026-02-27 22:29:07.835999+00	4b843f69-8041-4846-8af4-872de4c5c41e	Kiloan - Cuci, Setrika
3a2e7316-aba0-4e03-87ce-62d303fc3337	KG	2026-02-27 22:29:07.835999+00	4b843f69-8041-4846-8af4-872de4c5c41e	Kiloan - Cuci
01d0732a-21dd-4a6e-84a8-a927949ea2e9	PCS	2026-02-27 22:29:07.835999+00	4b843f69-8041-4846-8af4-872de4c5c41e	Jas
1a34658f-5391-4820-a6d3-0aec6d869f94	PCS	2026-02-27 22:29:07.835999+00	4b843f69-8041-4846-8af4-872de4c5c41e	Boneka
24e92d13-4c36-4f43-80e8-595cea91670f	PCS	2026-02-27 22:29:07.835999+00	4b843f69-8041-4846-8af4-872de4c5c41e	Bedcover
b5532d4b-3b4e-4a47-9199-300c25b3d5b0	PCS	2026-02-27 22:29:07.835999+00	4b843f69-8041-4846-8af4-872de4c5c41e	Selimut
\.


--
-- Data for Name: service_duration; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.service_duration (service, price, id, created_at, duration) FROM stdin;
53690299-8319-451b-b341-c8fe6f907052	12000	f02bd831-dd08-4fc3-9f61-6b3e982a549c	2024-11-11 13:38:47.589246+00	729e485e-5fd7-4b71-b265-16eae1a32710
1b9f8954-a53f-4b9d-8e4e-5dcdc6f774c9	12000	5f605362-d202-48f1-b7fc-b4597785e7fc	2024-11-11 13:38:48.972731+00	729e485e-5fd7-4b71-b265-16eae1a32710
36df7c6e-62fc-4fd0-899f-df6d055000ef	12000	7a8ab69e-d9ef-4349-b45c-86e52e438d23	2024-11-11 13:38:50.06894+00	729e485e-5fd7-4b71-b265-16eae1a32710
6815b87c-940d-4ddb-8f4b-ec571fce4aac	12	19b8faaa-07f0-4316-8a3d-ebafb54118c0	2025-01-28 08:05:15.113387+00	69ccec93-7da2-4c29-9966-d87166764089
8ae334d7-f77f-4eff-8ebb-aa27efb0a6ac	12000	9ee1f9d2-04e0-4b21-bbcd-c659edd1d78d	2024-11-11 13:39:07.05696+00	729e485e-5fd7-4b71-b265-16eae1a32710
f0b42481-499d-4425-8917-af7538643455	12000	72aba673-0576-4765-a701-c61cf747abbb	2024-11-11 13:39:08.580317+00	729e485e-5fd7-4b71-b265-16eae1a32710
b702a4a0-06e3-4f70-9586-faca4c21b18e	12000	089cba58-4d03-4f89-8da9-0883c1216eb8	2024-11-11 13:39:08.58449+00	729e485e-5fd7-4b71-b265-16eae1a32710
6fe86e6e-3084-48d7-97d3-9520a75c026c	983	55dbe1a0-c7b3-4fc1-99eb-b696d9768b8d	2025-01-29 00:52:15.050043+00	34e37144-d89e-4bea-92e7-4670f4b1ca46
1e183082-ed17-49d6-a577-aed879b11b42	12000	856a18f3-dfcf-408c-924f-5849c1f06eea	2024-11-11 13:39:26.524851+00	729e485e-5fd7-4b71-b265-16eae1a32710
c5e4beb5-b49a-4b92-88a5-3ae2258dab84	12000	a9d6bd9b-b9b6-4e87-b3b9-7f49a11e5c7e	2024-11-11 13:39:27.648836+00	729e485e-5fd7-4b71-b265-16eae1a32710
f203f297-852b-453d-8276-6665abb8ff2a	12000	0ea4444c-c17a-4ee5-a9aa-c8c1bbe70e53	2024-11-11 13:39:27.762122+00	729e485e-5fd7-4b71-b265-16eae1a32710
0b1fe87d-9114-413f-aed1-7d452e50af03	12000	f8bd8d2b-2928-4aa7-9b86-445ac495ab8b	2024-11-11 13:39:47.229507+00	729e485e-5fd7-4b71-b265-16eae1a32710
10bcb992-1762-47ba-878a-648f7cf4b732	12000	30b526f5-93da-481f-af1d-ac5e8dd3f5f7	2024-11-11 13:39:47.440671+00	729e485e-5fd7-4b71-b265-16eae1a32710
4887d5b3-4beb-43d6-ab15-a447b9655b5d	12000	e747efcd-70a0-44fb-adbe-c6ead9e458b8	2024-11-11 13:40:08.301863+00	729e485e-5fd7-4b71-b265-16eae1a32710
5538a2f9-67ea-4e22-9b36-872247e6d20b	12000	c2337494-aea6-4176-9c51-91f4f0d7bdc6	2024-11-11 13:40:34.589937+00	729e485e-5fd7-4b71-b265-16eae1a32710
8493e97e-a574-4f93-a88a-ca2f7a6f617f	12000	b0884038-c643-4823-a2c5-6849cd15f939	2024-11-11 13:40:36.502909+00	729e485e-5fd7-4b71-b265-16eae1a32710
458126fc-4a90-4540-893c-b281c06f4325	12000	f05498b9-73a0-4b66-ab54-987f9186a387	2024-11-11 13:40:40.588762+00	729e485e-5fd7-4b71-b265-16eae1a32710
ff267bd5-99a9-4b90-ad69-fe701f2adf81	12000	5dbd6cda-5dc1-475f-9d6a-bca95f0021a1	2024-11-11 13:40:45.780561+00	729e485e-5fd7-4b71-b265-16eae1a32710
84c459f7-426a-4934-85f2-bf87067bffe7	789	06234d48-e80c-4b14-86e4-22e40b92c59a	2025-01-29 07:18:31.489119+00	87d2b416-20bc-4af4-9e82-c982469e2649
e041cc17-bdbb-4d6b-85fd-5afa2d3cd51c	12000	9d23ee4d-a182-48ac-b35b-d01ad23d7331	2024-11-11 13:40:48.516405+00	729e485e-5fd7-4b71-b265-16eae1a32710
7826f0b4-b1e3-465b-bb03-fc1e174299b4	12000	66328441-8b74-4849-8a02-1de85a5dce44	2024-11-11 13:40:56.65278+00	729e485e-5fd7-4b71-b265-16eae1a32710
94305336-ae4e-44f0-92f1-602fbf48e764	12000	1fa54e8e-6c28-449f-baa9-e50ec3e4786e	2024-11-11 13:40:59.497286+00	729e485e-5fd7-4b71-b265-16eae1a32710
5f3971a3-8d2f-4f9a-bfa3-15d59adffaf4	12000	3e081819-dfaf-4c83-bb87-b6d4719b07bc	2024-11-11 13:41:05.581263+00	729e485e-5fd7-4b71-b265-16eae1a32710
522f4f75-4e5b-42ea-9b3f-746ba43eec47	12000	71101d7e-d16c-418b-8621-f97225b4850c	2024-11-11 13:41:05.958307+00	729e485e-5fd7-4b71-b265-16eae1a32710
4a0cc414-588a-4aa2-bf1a-e64d2361cd9f	12000	a5772ca7-a170-44ee-b923-761596b871b2	2024-11-11 13:41:06.936307+00	729e485e-5fd7-4b71-b265-16eae1a32710
aa613fa0-5525-462e-beba-cbb29b6ef26b	12000	5d55bec0-f99a-4ce2-a645-cc078a821d9a	2024-11-11 13:41:25.216353+00	729e485e-5fd7-4b71-b265-16eae1a32710
06e9cc26-ba82-4bdb-9664-ce1c6221b322	12000	dfa68322-cd1a-4603-9210-0eeea84edb46	2024-11-11 13:41:49.083885+00	729e485e-5fd7-4b71-b265-16eae1a32710
b4981875-fc9a-45e8-9f41-b794197831ee	12000	d06c76fa-2b9b-4c66-bff0-4a986884aadf	2024-11-11 13:41:53.743856+00	729e485e-5fd7-4b71-b265-16eae1a32710
b0549c28-69ee-4fe6-ace8-c8123d6b8411	12000	1cbff4f2-8417-4cc2-baed-d72d47611d4b	2024-11-11 13:41:54.849207+00	729e485e-5fd7-4b71-b265-16eae1a32710
17b12d16-8e0f-4269-bc73-b0e335767788	12000	e5c93033-4e2b-448a-a124-24faca413926	2024-11-11 13:42:04.237177+00	729e485e-5fd7-4b71-b265-16eae1a32710
43b82559-147d-4703-8e4c-53636f40817d	12000	d2265c1b-fe29-44ce-b7f7-1376813e699f	2024-11-11 13:42:09.774957+00	729e485e-5fd7-4b71-b265-16eae1a32710
3f936b70-3f91-4442-ad39-4748f8541807	12000	df81d71e-f923-43a6-a440-6645e9b50ea0	2024-11-11 13:42:10.175322+00	729e485e-5fd7-4b71-b265-16eae1a32710
2da5d742-44e3-4537-908b-00ddbadc8a46	9	6171dbc4-6cdf-4acf-8dc5-424e0a0b1619	2025-02-05 22:28:16.787664+00	87d2b416-20bc-4af4-9e82-c982469e2649
7e9dd14a-04f9-4ee2-89aa-0f06d56d69ad	6	ed5ceb0d-0197-4e72-b79a-c87a12ad9d60	2025-02-05 22:28:26.196714+00	0a60c69c-79fe-4a08-b68e-f80c5b8e8a37
1daed629-00c7-4f8d-b20c-723130cb3b45	12000	714f8ca1-6436-44bf-b035-43bdf2e33c71	2024-11-11 13:42:13.64902+00	729e485e-5fd7-4b71-b265-16eae1a32710
72103d77-0197-4dd3-a45a-1336c46253f7	12000	2439d0cc-1c87-4d43-b019-63afa97699ab	2024-11-11 13:42:14.90854+00	729e485e-5fd7-4b71-b265-16eae1a32710
7e9dd14a-04f9-4ee2-89aa-0f06d56d69ad	36	517ca33c-2773-45fe-af38-fa0a9c09a295	2025-02-05 22:28:26.417558+00	87d2b416-20bc-4af4-9e82-c982469e2649
7e9dd14a-04f9-4ee2-89aa-0f06d56d69ad	3	b1b51102-84f2-4ff5-a0b1-1bbb2301b5cf	2025-02-05 22:28:26.638407+00	b10de791-9a1d-4723-b0c9-f67a00894f47
2ef3eccd-f1e0-4d48-be8d-e4145eaf4dca	12000	3a257ce5-a88e-4ca0-bc12-a411112a6e0a	2024-11-11 13:42:18.521111+00	729e485e-5fd7-4b71-b265-16eae1a32710
1e01d0bd-85ac-423f-8a8c-3e8c27450837	12000	2f98657a-17e4-4648-b76b-9048384df32d	2024-11-11 13:42:20.70872+00	729e485e-5fd7-4b71-b265-16eae1a32710
137d5b80-a174-432d-acbf-723bdbd0f389	10000	00cb8cad-4628-406c-8735-1afe90687ebe	2025-02-17 07:40:27.177256+00	da8cc09f-4568-4ed8-839b-2195b4e5040e
a67f9255-92b5-4782-afdf-5d96137021c3	12000	a6b4f09b-55b5-44e7-8746-6f5ca0f516c0	2024-11-11 13:42:33.186969+00	729e485e-5fd7-4b71-b265-16eae1a32710
5fc0b116-89d6-4cf8-b516-c063c3f841ed	12000	2bcad2f8-1275-44af-a1a2-c98a76db8e3a	2024-11-11 13:42:34.402302+00	729e485e-5fd7-4b71-b265-16eae1a32710
0c6f5479-3ddc-4df8-b887-9044c1d0d6a9	10000	703f6bc8-7bae-4f27-8b30-d6dd66081ec2	2025-03-07 12:43:52.928216+00	70ff1f47-4bf3-40df-9f9c-86d186cefb2a
995b7863-4eb7-4f2f-b02c-c85b762ffb68	2891	4b51c664-9dfe-4754-ba5a-b21db25f7031	2025-03-07 13:00:25.433306+00	70ff1f47-4bf3-40df-9f9c-86d186cefb2a
6a3ab264-50b2-4b58-8b77-ab2acbc51b9a	12000	c0a25767-334f-4414-aab5-bf8f120af721	2024-11-11 13:42:38.612308+00	729e485e-5fd7-4b71-b265-16eae1a32710
d0af25e2-ef39-429b-855d-b393a500894b	9238	470b16f0-0aa9-46dd-b7b3-968d3cdf223e	2025-03-07 13:01:24.449536+00	70ff1f47-4bf3-40df-9f9c-86d186cefb2a
1e89b888-2366-4981-8b1d-ac34373fc48a	12000	7bb056dc-a84e-4a3a-be28-855ae2209917	2024-11-11 13:42:43.69722+00	729e485e-5fd7-4b71-b265-16eae1a32710
b57b3464-80f0-490f-8eaf-d1c509148151	728	13804c03-ca6d-413d-8433-7bbe8faf2140	2025-03-07 13:02:24.775099+00	70ff1f47-4bf3-40df-9f9c-86d186cefb2a
ae717658-9898-45da-b79b-76408108b220	12000	a0d42369-678a-44ad-97bc-4131c6e87a80	2024-11-11 13:42:52.638037+00	729e485e-5fd7-4b71-b265-16eae1a32710
f6b7c4c4-38c6-47d3-877e-7dfdc327be85	12000	15d3e52a-d5c1-4c9a-b715-7412eca41bab	2024-11-11 13:42:53.855232+00	729e485e-5fd7-4b71-b265-16eae1a32710
3c51c003-b6e0-4b36-bdca-a84c7d27bd7e	128	570788c8-356a-4c3e-b44b-27492cda4a5f	2025-03-07 13:02:40.845973+00	70ff1f47-4bf3-40df-9f9c-86d186cefb2a
5af59d23-d481-4e46-ba02-dc4b6a749f0b	12000	5df96bee-17c1-4f5a-b151-1c2b49ce7132	2024-11-11 13:43:07.394923+00	729e485e-5fd7-4b71-b265-16eae1a32710
fd7c2970-cb3b-4230-bd58-3f9cfac29c82	728	46ae9350-a28b-4d97-aa42-fd3d178db39a	2025-03-07 13:03:00.843165+00	70ff1f47-4bf3-40df-9f9c-86d186cefb2a
85775326-947d-482b-865c-76e131a93203	12000	2a57de6e-e558-43f0-a0a2-dec10249b656	2024-11-11 13:43:13.830616+00	729e485e-5fd7-4b71-b265-16eae1a32710
12134389-7bea-4f18-870d-ab2bb41944dd	81	ee22f77f-6d3d-4202-9b85-fba1a3607f64	2025-03-07 13:03:52.435327+00	70ff1f47-4bf3-40df-9f9c-86d186cefb2a
10093706-abcb-4b8c-bf02-4134000b5755	12000	41b5cba2-7207-4589-b6c9-97b1784c8846	2024-11-11 13:43:17.803672+00	729e485e-5fd7-4b71-b265-16eae1a32710
6ae4fa1c-62e6-4e69-8f7b-99868caf2ac3	8	e2ca7372-eaef-4430-a1d2-7a95a9e8f9c7	2025-03-07 13:04:13.523409+00	70ff1f47-4bf3-40df-9f9c-86d186cefb2a
16b6b107-5883-42ed-907e-854076ec15be	12000	1cfce958-1b34-4185-b472-6a7878b9c942	2024-11-11 13:43:24.286887+00	729e485e-5fd7-4b71-b265-16eae1a32710
8275d150-2d01-4b06-8515-a2ef8c9e6be9	12000	2df8832b-5ba2-4672-b6d4-c6df2b107ba9	2024-11-11 13:43:26.254887+00	729e485e-5fd7-4b71-b265-16eae1a32710
0cef9b3e-1552-4c21-b0ae-9267423592d1	10000	5f240224-c651-4542-b2cc-96468ac6991a	2024-11-16 02:34:05.255942+00	d01573c0-7953-49b3-9836-1c6083381d09
7676c149-9f68-4106-a4a6-7cca645d04d8	12	3d6da8e2-f7f4-4c6c-a858-60c9d4584493	2025-03-07 13:05:07.130422+00	70ff1f47-4bf3-40df-9f9c-86d186cefb2a
70db1bf9-e2b5-4947-868f-a1f61afe185e	12000	1d6dba90-6f51-4253-8438-7f85f5f82d3e	2024-12-15 09:25:13.060712+00	0c9ecec6-db7b-4d8e-9aa1-01a28ef5ea51
2c021478-4326-447b-b52c-8fd617861779	82	1aa4e6b2-1083-445b-b9c8-446e3424286e	2025-03-09 07:21:27.45238+00	70ff1f47-4bf3-40df-9f9c-86d186cefb2a
19cfbd67-2029-4a63-88f9-b3a0efcb9fe5	23000	3200be2f-e5f0-441a-bc2e-f4d3938483c8	2025-03-09 14:35:10.140355+00	82e31065-2aa3-42a8-8bea-f9b6f4c6f82c
bde7789f-c453-4370-ab87-76f2f600370a	6000	52ecd3c1-605c-47f0-bbe4-400d785355e3	2025-03-16 06:08:49.695675+00	c44f4d8c-2cfb-4a97-aae6-8aa94070488e
bde7789f-c453-4370-ab87-76f2f600370a	8000	1466a54f-66a7-49a3-9e0e-0d9bdcdc4f65	2025-03-16 06:08:49.695675+00	8b85ab01-03dd-42d1-b50c-0b55668d8603
bde7789f-c453-4370-ab87-76f2f600370a	12000	33ee7889-34e1-42a3-ab2e-907661e417d6	2025-03-16 06:08:49.695675+00	b2f76778-4cff-4606-b51a-27b8d8f3bf9a
f529e5c0-83e1-4aac-9ae7-382881d3957b	4000	e940fb34-803b-4283-88d5-161989b83cc8	2025-03-16 06:08:49.695675+00	c44f4d8c-2cfb-4a97-aae6-8aa94070488e
f529e5c0-83e1-4aac-9ae7-382881d3957b	6000	6cf3a3e3-538a-45c1-8197-0e42c6424a90	2025-03-16 06:08:49.695675+00	8b85ab01-03dd-42d1-b50c-0b55668d8603
f529e5c0-83e1-4aac-9ae7-382881d3957b	8000	41c744b1-3c81-4a55-a234-35fa9bd7966e	2025-03-16 06:08:49.695675+00	b2f76778-4cff-4606-b51a-27b8d8f3bf9a
e3977a1c-a919-44c6-a2b4-178ae2c1cf80	20000	510ef493-71dd-45fa-8818-45997fb69f17	2025-03-16 06:08:49.695675+00	c44f4d8c-2cfb-4a97-aae6-8aa94070488e
e3977a1c-a919-44c6-a2b4-178ae2c1cf80	25000	38b9d63c-3f5e-4491-b347-8f3c44a66b8c	2025-03-16 06:08:49.695675+00	8b85ab01-03dd-42d1-b50c-0b55668d8603
e3977a1c-a919-44c6-a2b4-178ae2c1cf80	30000	63a1a2f6-ed92-4f8d-aaa7-59d628ebdf00	2025-03-16 06:08:49.695675+00	b2f76778-4cff-4606-b51a-27b8d8f3bf9a
62f8f9c0-c04d-4d09-9e06-8a0358e2f744	12000	c2f94d01-11dc-4c23-92c3-aa73360eb35a	2025-01-19 01:18:15.719216+00	8bb5bb41-a20e-4da4-90f1-e265475cfb21
62f8f9c0-c04d-4d09-9e06-8a0358e2f744	10000	3a6ffba7-9b4e-4206-9b66-8b830a0c5c55	2025-01-19 01:18:15.936273+00	c7f012d5-7941-4020-b976-42e04d182001
bb807b3e-fef1-4c39-b3ed-1118a69b3a78	12000	492fd119-be2d-4ddc-a13c-8cd4eff9120f	2025-01-19 01:18:32.308641+00	3303a779-44b1-4844-90ad-a109e92fe1f5
628bff68-94f5-4175-b05f-87efd6b0a74c	123213	d164c5a0-bca4-4d4f-9f13-50c63dbbd1e5	2025-01-19 02:53:27.796638+00	9d7f60ab-b124-4cbf-a642-6bf5a72e4ca7
6d35a211-8b56-4394-af11-b4152f0f216c	12	1faeb991-e4fe-44f2-ad05-d96d6a413ea7	2025-01-19 02:55:18.278885+00	9d7f60ab-b124-4cbf-a642-6bf5a72e4ca7
a5b1cffe-fd5c-40a2-af12-6710070dcd23	12	8a4a0a4d-effd-4617-bb36-7be3af145fec	2025-01-19 02:55:34.434425+00	9d7f60ab-b124-4cbf-a642-6bf5a72e4ca7
c896855a-8058-4f29-8959-4ba7ee172635	11	84c2771a-6400-4702-b705-5ed9be28a136	2025-01-19 02:55:46.933782+00	365e01f2-1da7-4fdd-b48a-db479c9a74c0
e7a8008f-c8b0-4890-bf0b-dd99b6bdfd77	12000	61e63c5e-24bd-401c-a104-7bca861fc6e8	2025-01-19 02:57:37.13532+00	5add6b4d-1e9c-4a46-920f-093789f4b340
ac245503-be49-4e24-98da-c89ba79edb5a	12000	a51b1029-000b-4ea6-9fe0-57e88b7642b1	2025-01-19 02:58:03.800153+00	3303a779-44b1-4844-90ad-a109e92fe1f5
ba121bef-0598-479f-b731-da63b2fe21e8	13000	c4dcc9ff-8663-44c1-98f3-5f5b7bdd2b77	2025-01-19 02:58:27.214139+00	c7f012d5-7941-4020-b976-42e04d182001
c6115e3c-1cec-4d66-8633-afa8edc58f89	36000	d7670c8c-6c2d-4624-ae95-3697d867058c	2025-01-25 14:50:14.400716+00	c76f1b47-3360-4fd1-83a5-3f50a7620e35
5c76318d-2be6-445a-bdb1-e5ae05ae32be	290000	6eacdfd2-5d61-4df5-a910-5b77b7a9ba41	2025-01-25 14:50:40.389787+00	39b9ea9f-323c-425a-90bd-fc800005104c
e3bab34f-a7cd-425f-ab5e-ac7451cfcad1	30000	9e3412ca-c233-4f88-97c0-2828d7c2f264	2025-03-16 06:08:49.695675+00	c44f4d8c-2cfb-4a97-aae6-8aa94070488e
e3bab34f-a7cd-425f-ab5e-ac7451cfcad1	20000	c0359ee7-e5b5-412f-870d-0933e6b6ecc6	2025-03-16 06:08:49.695675+00	8b85ab01-03dd-42d1-b50c-0b55668d8603
e3bab34f-a7cd-425f-ab5e-ac7451cfcad1	10000	5758b5f2-9d5a-4b03-9864-59047def7eef	2025-03-16 06:08:49.695675+00	b2f76778-4cff-4606-b51a-27b8d8f3bf9a
9406b6dd-3ee6-4ce7-84f6-3ee3e850d2bc	5000	fd433ae1-373f-4934-8499-aacfb2ef3c7d	2025-03-16 06:08:49.695675+00	c44f4d8c-2cfb-4a97-aae6-8aa94070488e
9406b6dd-3ee6-4ce7-84f6-3ee3e850d2bc	10000	47eed538-4799-4e0e-a62e-22e88f4ef63e	2025-03-16 06:08:49.695675+00	8b85ab01-03dd-42d1-b50c-0b55668d8603
9406b6dd-3ee6-4ce7-84f6-3ee3e850d2bc	15000	1ccca0a9-fbac-4122-b2b8-2c3d3f26045a	2025-03-16 06:08:49.695675+00	b2f76778-4cff-4606-b51a-27b8d8f3bf9a
3aea9d26-db35-48b9-b662-7bffeea608d0	5000	56de1cbf-bdb3-4924-8caf-09c636d4fd85	2025-03-16 06:08:49.695675+00	c44f4d8c-2cfb-4a97-aae6-8aa94070488e
3aea9d26-db35-48b9-b662-7bffeea608d0	10000	3218a985-26c9-46d3-8731-d6722254a9ac	2025-03-16 06:08:49.695675+00	8b85ab01-03dd-42d1-b50c-0b55668d8603
3aea9d26-db35-48b9-b662-7bffeea608d0	15000	4fd9f8f6-982c-45f8-b773-76dc2be8c06b	2025-03-16 06:08:49.695675+00	b2f76778-4cff-4606-b51a-27b8d8f3bf9a
fa83745e-e2d3-45b2-80f8-8c6a7f8f84d9	6000	01081373-e3ec-4697-a9c8-5bc2de4bd129	2025-03-16 07:23:02.018489+00	580784cc-7a28-4b36-be39-1800dc29b2d7
fa83745e-e2d3-45b2-80f8-8c6a7f8f84d9	8000	ce4a82e3-178f-49bd-9db6-44cb37d85fa1	2025-03-16 07:23:02.018489+00	241e98f3-1e78-4893-805d-93a1ff5b3020
fa83745e-e2d3-45b2-80f8-8c6a7f8f84d9	12000	73af1634-0b18-43ea-b4c8-81ffa168bbf9	2025-03-16 07:23:02.018489+00	049ea0e0-b96d-4cf4-8b7e-6e1ae6df0566
d571725c-5ebd-4d1c-bfdf-dad125b55c58	4000	a979d29e-f4a7-4933-a3cd-bd653eeb481f	2025-03-16 07:23:02.018489+00	580784cc-7a28-4b36-be39-1800dc29b2d7
d571725c-5ebd-4d1c-bfdf-dad125b55c58	6000	209ca7d6-cb71-41a2-ad4d-3600a1ccac4e	2025-03-16 07:23:02.018489+00	241e98f3-1e78-4893-805d-93a1ff5b3020
d571725c-5ebd-4d1c-bfdf-dad125b55c58	8000	b085fbfd-967e-49fd-b401-686e70a3e13e	2025-03-16 07:23:02.018489+00	049ea0e0-b96d-4cf4-8b7e-6e1ae6df0566
5e0c5fc1-558a-4198-9019-5d7914d164a6	20000	06ad989e-b51a-4f78-8dac-3cb13e631257	2025-03-16 07:23:02.018489+00	580784cc-7a28-4b36-be39-1800dc29b2d7
5e0c5fc1-558a-4198-9019-5d7914d164a6	25000	46eae7e0-a2cc-4e4c-a5f4-13ee8d73e027	2025-03-16 07:23:02.018489+00	241e98f3-1e78-4893-805d-93a1ff5b3020
5e0c5fc1-558a-4198-9019-5d7914d164a6	30000	89840259-da03-4d91-94cd-5ddab7704990	2025-03-16 07:23:02.018489+00	049ea0e0-b96d-4cf4-8b7e-6e1ae6df0566
9c98fe1c-8467-4e3e-a90f-f25044b16c2b	30000	5ecfaeb5-c9a0-43e3-8a7b-13c3547c56f5	2025-03-16 07:23:02.018489+00	580784cc-7a28-4b36-be39-1800dc29b2d7
9c98fe1c-8467-4e3e-a90f-f25044b16c2b	20000	593194ab-d2ca-4802-a8d7-d57848017a04	2025-03-16 07:23:02.018489+00	241e98f3-1e78-4893-805d-93a1ff5b3020
9c98fe1c-8467-4e3e-a90f-f25044b16c2b	10000	e014ccb2-811a-4c54-9035-e4c841787d17	2025-03-16 07:23:02.018489+00	049ea0e0-b96d-4cf4-8b7e-6e1ae6df0566
5a4a4700-286c-4ccd-a00f-781a1dc2521e	5000	0fcbaa62-57f9-4d96-b3ab-a1d2a0133ed9	2025-03-16 07:23:02.018489+00	580784cc-7a28-4b36-be39-1800dc29b2d7
5a4a4700-286c-4ccd-a00f-781a1dc2521e	10000	b5c116c8-2e97-4287-b0dc-0d555b5d4496	2025-03-16 07:23:02.018489+00	241e98f3-1e78-4893-805d-93a1ff5b3020
5a4a4700-286c-4ccd-a00f-781a1dc2521e	15000	3cfe4e4d-d760-448c-8379-974740207137	2025-03-16 07:23:02.018489+00	049ea0e0-b96d-4cf4-8b7e-6e1ae6df0566
9b1fd099-8793-4368-9cdf-73565dc9244f	5000	4c8aa586-ff6e-4ba7-8ff9-3f34fa0e41ad	2025-03-16 07:23:02.018489+00	580784cc-7a28-4b36-be39-1800dc29b2d7
9b1fd099-8793-4368-9cdf-73565dc9244f	10000	7c0f3d80-2ac3-4753-a2c6-4ac3c6b7eb31	2025-03-16 07:23:02.018489+00	241e98f3-1e78-4893-805d-93a1ff5b3020
9b1fd099-8793-4368-9cdf-73565dc9244f	15000	d17d01ae-1b89-4ef8-847a-a59541866d47	2025-03-16 07:23:02.018489+00	049ea0e0-b96d-4cf4-8b7e-6e1ae6df0566
7a4308e0-95f1-4c6c-8bb9-340ab32f7037	6000	f08ec55b-f636-4034-b996-8d4b5271b6fb	2025-03-17 11:04:06.779175+00	45d1dc31-2661-419c-adef-7435d6d78e84
7a4308e0-95f1-4c6c-8bb9-340ab32f7037	8000	7904761d-a781-49e1-a583-8269f54877a0	2025-03-17 11:04:06.779175+00	eee62488-98c2-4cb8-a87e-e42e866ba3e5
7a4308e0-95f1-4c6c-8bb9-340ab32f7037	12000	721c030e-e322-4c3d-a5a5-19bbb23084d4	2025-03-17 11:04:06.779175+00	773f9d43-8cc5-4223-a612-179acc97d74a
a9d0e4f3-75ac-4356-9832-f50d04343c9b	4000	ac6617c8-c4be-40f1-8dda-b4400e20e954	2025-03-17 11:04:06.779175+00	45d1dc31-2661-419c-adef-7435d6d78e84
a9d0e4f3-75ac-4356-9832-f50d04343c9b	6000	73aec8b1-07b1-42d1-b3ae-5b1bf7f1e5e4	2025-03-17 11:04:06.779175+00	eee62488-98c2-4cb8-a87e-e42e866ba3e5
a9d0e4f3-75ac-4356-9832-f50d04343c9b	8000	30c8214b-caec-4e4b-b7db-36fed764d99d	2025-03-17 11:04:06.779175+00	773f9d43-8cc5-4223-a612-179acc97d74a
1e133026-6c7d-4355-86d5-8fbe497cad26	20000	7e3362ce-a146-4e65-bc36-24c41bcf8fc1	2025-03-17 11:04:06.779175+00	45d1dc31-2661-419c-adef-7435d6d78e84
1e133026-6c7d-4355-86d5-8fbe497cad26	25000	489ff5bc-9a6f-467d-ae1d-593eff967591	2025-03-17 11:04:06.779175+00	eee62488-98c2-4cb8-a87e-e42e866ba3e5
1e133026-6c7d-4355-86d5-8fbe497cad26	30000	09f0e5e5-fcd0-4481-b508-a90eda930dfc	2025-03-17 11:04:06.779175+00	773f9d43-8cc5-4223-a612-179acc97d74a
8bf76fec-375a-4851-b791-00daa5e355c7	30000	ea0884a8-29db-49cd-9d42-2ee5607a68e3	2025-03-17 11:04:06.779175+00	45d1dc31-2661-419c-adef-7435d6d78e84
8bf76fec-375a-4851-b791-00daa5e355c7	20000	e8d0813d-b71b-4842-986e-bdbb934a0111	2025-03-17 11:04:06.779175+00	eee62488-98c2-4cb8-a87e-e42e866ba3e5
8bf76fec-375a-4851-b791-00daa5e355c7	10000	08e5a606-375c-45d4-9f94-29bba92ffe31	2025-03-17 11:04:06.779175+00	773f9d43-8cc5-4223-a612-179acc97d74a
eabfbd54-8fd3-400b-b610-44e60dd5576e	5000	4266871e-2cd5-4d21-b346-001b6bf8deb9	2025-03-17 11:04:06.779175+00	45d1dc31-2661-419c-adef-7435d6d78e84
eabfbd54-8fd3-400b-b610-44e60dd5576e	10000	1af6b022-3bfc-470a-977f-523d01013b79	2025-03-17 11:04:06.779175+00	eee62488-98c2-4cb8-a87e-e42e866ba3e5
eabfbd54-8fd3-400b-b610-44e60dd5576e	15000	751e3ee8-88bf-4f00-a51e-39e03b4b1921	2025-03-17 11:04:06.779175+00	773f9d43-8cc5-4223-a612-179acc97d74a
728a11a6-c5d4-4c86-bea9-5d048d00bcb1	5000	2e6d9bb7-bf22-4b29-b41c-5d97373ef37e	2025-03-17 11:04:06.779175+00	45d1dc31-2661-419c-adef-7435d6d78e84
728a11a6-c5d4-4c86-bea9-5d048d00bcb1	10000	ef8b2a2e-2f31-4331-bd11-a9143ae12ce1	2025-03-17 11:04:06.779175+00	eee62488-98c2-4cb8-a87e-e42e866ba3e5
728a11a6-c5d4-4c86-bea9-5d048d00bcb1	15000	75a46c65-d8bb-417f-9b9f-ff1eed4d63c7	2025-03-17 11:04:06.779175+00	773f9d43-8cc5-4223-a612-179acc97d74a
f3805087-ec88-46fa-b844-cbb60f28c427	6000	d5cff2f4-9b3f-4423-8b89-1ed1a0169fc1	2025-03-17 12:55:08.283189+00	d7b81cf5-3ee6-4381-a475-68272701d889
f3805087-ec88-46fa-b844-cbb60f28c427	8000	70b35a30-317c-4713-8b0d-ae743ff42569	2025-03-17 12:55:08.283189+00	3dfa1b5c-a0ac-4944-85d6-2bfd7979ce2d
f3805087-ec88-46fa-b844-cbb60f28c427	12000	e65ae105-8143-4b6f-a6c9-eb8ebd4bbb24	2025-03-17 12:55:08.283189+00	a8561626-f333-4587-92fe-fd714c0ddabf
a43759e4-f70f-40cf-a16b-f9c81b9d1137	4000	e2762f16-43c2-4221-b586-43617412481a	2025-03-17 12:55:08.283189+00	d7b81cf5-3ee6-4381-a475-68272701d889
a43759e4-f70f-40cf-a16b-f9c81b9d1137	6000	5f4a0e40-3903-47bd-808a-386f09f5a6d3	2025-03-17 12:55:08.283189+00	3dfa1b5c-a0ac-4944-85d6-2bfd7979ce2d
a43759e4-f70f-40cf-a16b-f9c81b9d1137	8000	93292b3f-3c32-4bd4-ba90-f793f4ff5983	2025-03-17 12:55:08.283189+00	a8561626-f333-4587-92fe-fd714c0ddabf
10a3accc-cb40-4113-aa78-7bd19a42dc48	20000	dc2a93f4-463b-4adb-a608-c99dd27708b9	2025-03-17 12:55:08.283189+00	d7b81cf5-3ee6-4381-a475-68272701d889
10a3accc-cb40-4113-aa78-7bd19a42dc48	25000	3088abc7-41f5-4952-a080-0467ec265b67	2025-03-17 12:55:08.283189+00	3dfa1b5c-a0ac-4944-85d6-2bfd7979ce2d
10a3accc-cb40-4113-aa78-7bd19a42dc48	30000	493099d3-bd06-4911-bf6d-dfe5a99851d9	2025-03-17 12:55:08.283189+00	a8561626-f333-4587-92fe-fd714c0ddabf
95444c97-4a99-462b-ae08-bce4df2c8128	30000	7f773c40-b2d9-4f9a-89a0-90169713a057	2025-03-17 12:55:08.283189+00	d7b81cf5-3ee6-4381-a475-68272701d889
95444c97-4a99-462b-ae08-bce4df2c8128	20000	7e561de5-72e0-46a0-8542-e4f5d2931d23	2025-03-17 12:55:08.283189+00	3dfa1b5c-a0ac-4944-85d6-2bfd7979ce2d
95444c97-4a99-462b-ae08-bce4df2c8128	10000	c112f959-3153-45ad-9553-310bca1ca655	2025-03-17 12:55:08.283189+00	a8561626-f333-4587-92fe-fd714c0ddabf
8ee92283-5063-408e-9766-0f923be834d3	5000	b33acba5-fcad-4678-a87b-1bce72be29e8	2025-03-17 12:55:08.283189+00	d7b81cf5-3ee6-4381-a475-68272701d889
8ee92283-5063-408e-9766-0f923be834d3	10000	9c792d57-ca11-43f4-99e8-88da5d069100	2025-03-17 12:55:08.283189+00	3dfa1b5c-a0ac-4944-85d6-2bfd7979ce2d
8ee92283-5063-408e-9766-0f923be834d3	15000	62d08d87-373f-4288-8af1-4b8076d66dd1	2025-03-17 12:55:08.283189+00	a8561626-f333-4587-92fe-fd714c0ddabf
0c66962d-da42-41a5-9037-6e752122f370	5000	44a14948-baf8-41ea-b675-9ec31de31c11	2025-03-17 12:55:08.283189+00	d7b81cf5-3ee6-4381-a475-68272701d889
0c66962d-da42-41a5-9037-6e752122f370	10000	f11378ca-5f8d-49eb-a4e0-d6c7badea8d0	2025-03-17 12:55:08.283189+00	3dfa1b5c-a0ac-4944-85d6-2bfd7979ce2d
0c66962d-da42-41a5-9037-6e752122f370	15000	671e650f-eaed-4cbb-96d6-815e03d37db6	2025-03-17 12:55:08.283189+00	a8561626-f333-4587-92fe-fd714c0ddabf
a6914f53-f97e-48c0-a303-b99407203eec	6000	2b6226ce-771b-4592-b5ce-16f240b72a8f	2025-03-19 06:52:50.030774+00	684a54b5-f6ee-4593-ab4e-fb60dabe3617
a6914f53-f97e-48c0-a303-b99407203eec	8000	2641d8d3-66d5-4465-b9b6-3f6c76a68167	2025-03-19 06:52:50.030774+00	540d2188-2486-437f-b137-087a52875efd
a6914f53-f97e-48c0-a303-b99407203eec	12000	562e703e-37a2-4bb9-b797-d7c38ed46fe2	2025-03-19 06:52:50.030774+00	d3f6268b-bdac-41da-b100-9e2a68b99f32
d4f68248-ef01-4a21-aa7e-87edbb40e172	4000	e4ef16e1-4919-4d83-89c9-fd964f3eb1f0	2025-03-19 06:52:50.030774+00	684a54b5-f6ee-4593-ab4e-fb60dabe3617
d4f68248-ef01-4a21-aa7e-87edbb40e172	6000	b6f773b9-3bf5-4415-8b56-7a601481d2c8	2025-03-19 06:52:50.030774+00	540d2188-2486-437f-b137-087a52875efd
d4f68248-ef01-4a21-aa7e-87edbb40e172	8000	036d3c7e-bbda-40a2-ab6b-3bbde0573b82	2025-03-19 06:52:50.030774+00	d3f6268b-bdac-41da-b100-9e2a68b99f32
33e1f400-6336-4eb2-af25-2a80cb51bedb	20000	48cf4c8c-56ab-44dc-980b-65f4125e99c5	2025-03-19 06:52:50.030774+00	684a54b5-f6ee-4593-ab4e-fb60dabe3617
33e1f400-6336-4eb2-af25-2a80cb51bedb	25000	bae2b08a-0ef8-4a69-938c-8d38ad39d74d	2025-03-19 06:52:50.030774+00	540d2188-2486-437f-b137-087a52875efd
33e1f400-6336-4eb2-af25-2a80cb51bedb	30000	f87b8581-e454-4bb7-ad5b-160a2a82147b	2025-03-19 06:52:50.030774+00	d3f6268b-bdac-41da-b100-9e2a68b99f32
f3761434-33c5-4849-9d76-87a8b4f4e48d	30000	ac343a39-fa46-4473-bca0-6c92afb8f848	2025-03-19 06:52:50.030774+00	684a54b5-f6ee-4593-ab4e-fb60dabe3617
f3761434-33c5-4849-9d76-87a8b4f4e48d	20000	53d5915c-ccc0-41d8-ad1d-74c7809f4fdb	2025-03-19 06:52:50.030774+00	540d2188-2486-437f-b137-087a52875efd
f3761434-33c5-4849-9d76-87a8b4f4e48d	10000	c0f5d827-edb4-4194-b71f-ff0ea5ebaa68	2025-03-19 06:52:50.030774+00	d3f6268b-bdac-41da-b100-9e2a68b99f32
d386b90e-fa0e-41d3-9be0-2c0bc01c6ede	5000	0f7ef2c5-f9f7-4cf1-9832-83b924c61af2	2025-03-19 06:52:50.030774+00	684a54b5-f6ee-4593-ab4e-fb60dabe3617
d386b90e-fa0e-41d3-9be0-2c0bc01c6ede	10000	7c619eee-1a7c-4a90-a973-8724da546668	2025-03-19 06:52:50.030774+00	540d2188-2486-437f-b137-087a52875efd
d386b90e-fa0e-41d3-9be0-2c0bc01c6ede	15000	ce152ab8-8a48-4f17-9bc1-d7e09c5aa268	2025-03-19 06:52:50.030774+00	d3f6268b-bdac-41da-b100-9e2a68b99f32
4a2788a1-8766-4d00-b914-2676d650bccc	5000	e559880d-1fd8-4bf4-800d-69a7a6afc494	2025-03-19 06:52:50.030774+00	684a54b5-f6ee-4593-ab4e-fb60dabe3617
4a2788a1-8766-4d00-b914-2676d650bccc	10000	5bc606d5-3034-47d1-babd-87eb1692cd0a	2025-03-19 06:52:50.030774+00	540d2188-2486-437f-b137-087a52875efd
4a2788a1-8766-4d00-b914-2676d650bccc	15000	69e8d20b-e472-4b8b-9b54-87f4c38dd37f	2025-03-19 06:52:50.030774+00	d3f6268b-bdac-41da-b100-9e2a68b99f32
c4bb3d2b-b63d-4863-854d-3960997cf14f	6000	7ee0fb3a-a71e-415a-9481-29b21becdba9	2025-03-19 07:03:24.917247+00	2c2bd073-d741-432a-9325-ff7dba2b17a5
c4bb3d2b-b63d-4863-854d-3960997cf14f	8000	14a6eb40-a6ad-4bda-a707-a3cc9cb27712	2025-03-19 07:03:24.917247+00	7b91639e-e89f-4581-92ec-750ce30b4d8b
c4bb3d2b-b63d-4863-854d-3960997cf14f	12000	f0818a71-e0cf-478d-af86-424ff51e5912	2025-03-19 07:03:24.917247+00	8f181a7d-2634-4a6e-b589-cdf98a63fc69
941f2f91-9ec2-46fc-ad09-e01fd0426b08	4000	61b9cf66-9a18-468d-9b5e-c987199e8186	2025-03-19 07:03:24.917247+00	2c2bd073-d741-432a-9325-ff7dba2b17a5
941f2f91-9ec2-46fc-ad09-e01fd0426b08	6000	ca67bd2a-fd37-43c3-ae0d-b1ff8747da5d	2025-03-19 07:03:24.917247+00	7b91639e-e89f-4581-92ec-750ce30b4d8b
941f2f91-9ec2-46fc-ad09-e01fd0426b08	8000	f19ed9c6-9101-4f8e-99c1-c742147c5c43	2025-03-19 07:03:24.917247+00	8f181a7d-2634-4a6e-b589-cdf98a63fc69
2a7eeb2f-9be5-48c9-a280-5e8c4723b6ca	20000	f13b512b-cee4-425c-b586-57ccff5c2fa5	2025-03-19 07:03:24.917247+00	2c2bd073-d741-432a-9325-ff7dba2b17a5
2a7eeb2f-9be5-48c9-a280-5e8c4723b6ca	25000	7ebda7cd-f6cd-4b75-9d43-9e218b37091b	2025-03-19 07:03:24.917247+00	7b91639e-e89f-4581-92ec-750ce30b4d8b
2a7eeb2f-9be5-48c9-a280-5e8c4723b6ca	30000	01a67eb7-4ea1-44b2-8051-601ebc20dcc9	2025-03-19 07:03:24.917247+00	8f181a7d-2634-4a6e-b589-cdf98a63fc69
42aeef51-0daa-4417-80c8-d01392476562	30000	7af62fde-1514-428e-82d7-480d38404952	2025-03-19 07:03:24.917247+00	2c2bd073-d741-432a-9325-ff7dba2b17a5
42aeef51-0daa-4417-80c8-d01392476562	20000	100fd371-4c29-4f27-9c45-bbfb05c4b68f	2025-03-19 07:03:24.917247+00	7b91639e-e89f-4581-92ec-750ce30b4d8b
42aeef51-0daa-4417-80c8-d01392476562	10000	34eaec90-eaea-481c-92f7-1a5bda0bf76c	2025-03-19 07:03:24.917247+00	8f181a7d-2634-4a6e-b589-cdf98a63fc69
ed88d2bf-3d84-4bdd-9f07-bfbcc137fcae	5000	f7da7227-499a-495c-81d0-e431bf96cfad	2025-03-19 07:03:24.917247+00	2c2bd073-d741-432a-9325-ff7dba2b17a5
ed88d2bf-3d84-4bdd-9f07-bfbcc137fcae	10000	ba6cbc96-0ae7-48b6-ab81-8bcb8a3996a7	2025-03-19 07:03:24.917247+00	7b91639e-e89f-4581-92ec-750ce30b4d8b
ed88d2bf-3d84-4bdd-9f07-bfbcc137fcae	15000	86295f6d-a830-4e8a-872c-52555850b4ef	2025-03-19 07:03:24.917247+00	8f181a7d-2634-4a6e-b589-cdf98a63fc69
1a3cb704-c6d0-4c89-b2a6-662ef333d424	5000	107ecafa-2243-4cbd-b0b4-85aef398f145	2025-03-19 07:03:24.917247+00	2c2bd073-d741-432a-9325-ff7dba2b17a5
1a3cb704-c6d0-4c89-b2a6-662ef333d424	10000	29744ce7-aa2e-4907-8ff0-982b6e16f5c1	2025-03-19 07:03:24.917247+00	7b91639e-e89f-4581-92ec-750ce30b4d8b
1a3cb704-c6d0-4c89-b2a6-662ef333d424	15000	213f2ae8-230f-4546-8d3c-ba30ae1e2eeb	2025-03-19 07:03:24.917247+00	8f181a7d-2634-4a6e-b589-cdf98a63fc69
a62e1f00-2412-4fd6-b5b0-5a5f31f2c1f7	6000	2fd34adb-5ef7-44c0-affe-5260a22223c2	2025-03-19 14:08:06.83541+00	44528ccf-c690-4700-b842-8d5ace4e7722
a62e1f00-2412-4fd6-b5b0-5a5f31f2c1f7	8000	184ae887-7b6e-493f-addf-59744f6d91f3	2025-03-19 14:08:06.83541+00	a500410b-0563-4f68-a64d-acf30914e4f9
a62e1f00-2412-4fd6-b5b0-5a5f31f2c1f7	12000	e21d3ae3-45db-4297-b1f3-1f802a44233d	2025-03-19 14:08:06.83541+00	3acacf78-bb09-41e4-8cc5-1deef55583a9
145c45f4-b595-49bd-8158-e07d5f88972d	4000	1380022d-33b2-4818-99e5-4fade7e35d43	2025-03-19 14:08:06.83541+00	44528ccf-c690-4700-b842-8d5ace4e7722
145c45f4-b595-49bd-8158-e07d5f88972d	6000	75ff14f6-6fab-44fb-a9f3-27cbcd255ab4	2025-03-19 14:08:06.83541+00	a500410b-0563-4f68-a64d-acf30914e4f9
145c45f4-b595-49bd-8158-e07d5f88972d	8000	a2b684e6-833d-4d53-be92-f78f924c5b53	2025-03-19 14:08:06.83541+00	3acacf78-bb09-41e4-8cc5-1deef55583a9
a8f15201-9cbc-406e-adb5-52af094caf7e	20000	6dcea4c0-c543-4aaf-879e-7b1492feda0f	2025-03-19 14:08:06.83541+00	44528ccf-c690-4700-b842-8d5ace4e7722
a8f15201-9cbc-406e-adb5-52af094caf7e	25000	ca84d780-6cd5-479f-97f6-c1f1a912a2d6	2025-03-19 14:08:06.83541+00	a500410b-0563-4f68-a64d-acf30914e4f9
a8f15201-9cbc-406e-adb5-52af094caf7e	30000	d14926fd-7dd4-4593-a3db-bbd7ea283c4d	2025-03-19 14:08:06.83541+00	3acacf78-bb09-41e4-8cc5-1deef55583a9
62496ba5-8a9f-4aec-b7a2-05757f7cfad4	30000	7236766d-8711-4725-844d-74ac27f213eb	2025-03-19 14:08:06.83541+00	44528ccf-c690-4700-b842-8d5ace4e7722
62496ba5-8a9f-4aec-b7a2-05757f7cfad4	20000	354806ce-beb1-4cc6-9fe2-836d29ded7ed	2025-03-19 14:08:06.83541+00	a500410b-0563-4f68-a64d-acf30914e4f9
62496ba5-8a9f-4aec-b7a2-05757f7cfad4	10000	9b0a6680-6ded-44d2-8b5a-b1258dc6915f	2025-03-19 14:08:06.83541+00	3acacf78-bb09-41e4-8cc5-1deef55583a9
77296b8b-8e01-4b7a-a2f8-bdd70155c3fe	5000	c2b9c779-c241-49c3-9a30-adb94a7b2640	2025-03-19 14:08:06.83541+00	44528ccf-c690-4700-b842-8d5ace4e7722
77296b8b-8e01-4b7a-a2f8-bdd70155c3fe	10000	aa01eeb1-abf7-4389-9870-70cd8d66e780	2025-03-19 14:08:06.83541+00	a500410b-0563-4f68-a64d-acf30914e4f9
77296b8b-8e01-4b7a-a2f8-bdd70155c3fe	15000	c858625f-6640-4bfe-be8f-a09584093292	2025-03-19 14:08:06.83541+00	3acacf78-bb09-41e4-8cc5-1deef55583a9
4f9808a6-8b46-47fc-9db5-a50600fd8392	5000	1230f3fa-9e1f-4d7b-99ec-11cbf3134c57	2025-03-19 14:08:06.83541+00	44528ccf-c690-4700-b842-8d5ace4e7722
4f9808a6-8b46-47fc-9db5-a50600fd8392	10000	d9914d2d-2fc2-49ab-bc5b-35edb44f33dd	2025-03-19 14:08:06.83541+00	a500410b-0563-4f68-a64d-acf30914e4f9
4f9808a6-8b46-47fc-9db5-a50600fd8392	15000	8803078a-b6da-4230-95a1-086859b6e137	2025-03-19 14:08:06.83541+00	3acacf78-bb09-41e4-8cc5-1deef55583a9
0a3de9ff-648b-4b16-a621-7d734db64d6e	6000	e70a0b6e-162c-494a-b9dd-52edb74dd47c	2025-03-19 22:04:24.561145+00	03cb6f67-d2fb-4e33-bfed-d156e8fb4490
0a3de9ff-648b-4b16-a621-7d734db64d6e	8000	36eeb0c6-60a0-44d6-b9cb-e4e01a8f508a	2025-03-19 22:04:24.561145+00	51b6cadd-40f6-429d-b884-1fa05f5a39cc
0a3de9ff-648b-4b16-a621-7d734db64d6e	12000	97aa5a15-f678-40d2-b096-46b91310564e	2025-03-19 22:04:24.561145+00	3f5217bb-d508-42e2-ac80-8f02fd1e8f32
e2ee1d30-d396-4b89-8964-e87949d351c4	4000	175aa5f0-0635-448f-890e-f1ef4eb07baa	2025-03-19 22:04:24.561145+00	03cb6f67-d2fb-4e33-bfed-d156e8fb4490
e2ee1d30-d396-4b89-8964-e87949d351c4	6000	e051d52a-736e-4da1-90e4-9db90b663cac	2025-03-19 22:04:24.561145+00	51b6cadd-40f6-429d-b884-1fa05f5a39cc
e2ee1d30-d396-4b89-8964-e87949d351c4	8000	bf09a13b-44fa-44a5-b3ec-f5e35620b9b0	2025-03-19 22:04:24.561145+00	3f5217bb-d508-42e2-ac80-8f02fd1e8f32
7de5f2ec-a549-4544-b467-2b69b9daf4a6	20000	5b74d4ae-c648-41db-8f0a-f2f11c898476	2025-03-19 22:04:24.561145+00	03cb6f67-d2fb-4e33-bfed-d156e8fb4490
7de5f2ec-a549-4544-b467-2b69b9daf4a6	25000	c4cc6c9c-ff84-411d-83f6-a73f58b04bbd	2025-03-19 22:04:24.561145+00	51b6cadd-40f6-429d-b884-1fa05f5a39cc
7de5f2ec-a549-4544-b467-2b69b9daf4a6	30000	86a5bdec-c009-4d9e-9cfd-069cc0e18e5c	2025-03-19 22:04:24.561145+00	3f5217bb-d508-42e2-ac80-8f02fd1e8f32
00b743b6-9011-40bf-a904-89a7af010126	30000	81560c38-bbcd-4823-9180-4d68f4067462	2025-03-19 22:04:24.561145+00	03cb6f67-d2fb-4e33-bfed-d156e8fb4490
00b743b6-9011-40bf-a904-89a7af010126	20000	0b9c42d5-1c08-4aff-a75e-b94c19aedb6c	2025-03-19 22:04:24.561145+00	51b6cadd-40f6-429d-b884-1fa05f5a39cc
00b743b6-9011-40bf-a904-89a7af010126	10000	1cfd4b0d-95ec-4d42-8739-14755f7d0d04	2025-03-19 22:04:24.561145+00	3f5217bb-d508-42e2-ac80-8f02fd1e8f32
33331d29-0ba4-4731-9ffc-404d6e80e754	5000	7417cecf-a818-431e-8340-9b0743cec1ec	2025-03-19 22:04:24.561145+00	03cb6f67-d2fb-4e33-bfed-d156e8fb4490
33331d29-0ba4-4731-9ffc-404d6e80e754	10000	31a3c5a7-b0a1-4a97-989a-f0a958c2731f	2025-03-19 22:04:24.561145+00	51b6cadd-40f6-429d-b884-1fa05f5a39cc
33331d29-0ba4-4731-9ffc-404d6e80e754	15000	f30e71fc-9688-45e7-8ed2-d049bf334eaf	2025-03-19 22:04:24.561145+00	3f5217bb-d508-42e2-ac80-8f02fd1e8f32
a9601ae1-016e-4d5b-9510-9399533dca9e	5000	8c905b0c-b1e9-494b-a382-c557695a3624	2025-03-19 22:04:24.561145+00	03cb6f67-d2fb-4e33-bfed-d156e8fb4490
a9601ae1-016e-4d5b-9510-9399533dca9e	10000	3e93061b-340c-413b-9915-4c776ce6fb1a	2025-03-19 22:04:24.561145+00	51b6cadd-40f6-429d-b884-1fa05f5a39cc
a9601ae1-016e-4d5b-9510-9399533dca9e	15000	baeec301-a7df-4bcf-8258-cd9df54276ba	2025-03-19 22:04:24.561145+00	3f5217bb-d508-42e2-ac80-8f02fd1e8f32
25efee98-befa-466d-af62-03f23a8f8243	6000	976cf613-ffeb-4c11-8608-8c158e643fa6	2025-03-23 02:52:01.083343+00	3e806c8b-ea7f-4b1c-85b4-8112f6467a6b
25efee98-befa-466d-af62-03f23a8f8243	8000	942c6246-e49e-45cd-b98a-9acbdc139520	2025-03-23 02:52:01.083343+00	ef103202-4f12-48bd-961a-7467df0a37ec
25efee98-befa-466d-af62-03f23a8f8243	12000	4ad72f4e-adc6-4631-baa2-ffd8a6b82bfc	2025-03-23 02:52:01.083343+00	7c5d4526-5a3c-4ac1-836c-91b70c0b1295
e89bd934-db73-480a-a596-3ea6c4f9b9ee	4000	463a4acf-1fde-46e8-9e1e-4d4eb66fc8f8	2025-03-23 02:52:01.083343+00	3e806c8b-ea7f-4b1c-85b4-8112f6467a6b
e89bd934-db73-480a-a596-3ea6c4f9b9ee	6000	d7b9e7b4-f25f-4bea-9892-d7d801f38718	2025-03-23 02:52:01.083343+00	ef103202-4f12-48bd-961a-7467df0a37ec
e89bd934-db73-480a-a596-3ea6c4f9b9ee	8000	7bc90067-202e-4baf-8249-1443190955e6	2025-03-23 02:52:01.083343+00	7c5d4526-5a3c-4ac1-836c-91b70c0b1295
f28b12aa-910f-4912-96dc-00d871544cb7	20000	13483140-0d70-42f9-89ef-7803f3df7780	2025-03-23 02:52:01.083343+00	3e806c8b-ea7f-4b1c-85b4-8112f6467a6b
f28b12aa-910f-4912-96dc-00d871544cb7	25000	08afff0d-1233-459d-a94f-38e57b0a7d87	2025-03-23 02:52:01.083343+00	ef103202-4f12-48bd-961a-7467df0a37ec
f28b12aa-910f-4912-96dc-00d871544cb7	30000	d1259c96-79a0-4ec6-96e9-a20d4a56fa73	2025-03-23 02:52:01.083343+00	7c5d4526-5a3c-4ac1-836c-91b70c0b1295
163c0f6c-37d0-409a-be25-29ceff23c87b	30000	93a99b0f-7ea2-4d76-b4e0-2bd3165b12e9	2025-03-23 02:52:01.083343+00	3e806c8b-ea7f-4b1c-85b4-8112f6467a6b
163c0f6c-37d0-409a-be25-29ceff23c87b	20000	7037d1a5-f814-4195-8072-4586e972e05f	2025-03-23 02:52:01.083343+00	ef103202-4f12-48bd-961a-7467df0a37ec
163c0f6c-37d0-409a-be25-29ceff23c87b	10000	350f92ab-1c32-4cea-bdcf-ff8502b1edeb	2025-03-23 02:52:01.083343+00	7c5d4526-5a3c-4ac1-836c-91b70c0b1295
6a3810b5-87e1-4cf9-b838-6606e25afea9	5000	a47accbe-07a9-403a-aeec-f29b1de35435	2025-03-23 02:52:01.083343+00	3e806c8b-ea7f-4b1c-85b4-8112f6467a6b
6a3810b5-87e1-4cf9-b838-6606e25afea9	10000	1caf6d45-ba30-40a0-a9ef-30556eb32fcf	2025-03-23 02:52:01.083343+00	ef103202-4f12-48bd-961a-7467df0a37ec
6a3810b5-87e1-4cf9-b838-6606e25afea9	15000	90c506e0-3c4f-4dcd-8766-bb882f42fc1f	2025-03-23 02:52:01.083343+00	7c5d4526-5a3c-4ac1-836c-91b70c0b1295
069a6d70-bc91-40d2-84b5-2bced4bce078	5000	914a5e97-4630-422a-9a50-0d56de510306	2025-03-23 02:52:01.083343+00	3e806c8b-ea7f-4b1c-85b4-8112f6467a6b
069a6d70-bc91-40d2-84b5-2bced4bce078	10000	a6e694dd-9773-498c-bad9-6ef335e26e49	2025-03-23 02:52:01.083343+00	ef103202-4f12-48bd-961a-7467df0a37ec
069a6d70-bc91-40d2-84b5-2bced4bce078	15000	5fe3e737-52f9-4ff9-9a96-611143a2348d	2025-03-23 02:52:01.083343+00	7c5d4526-5a3c-4ac1-836c-91b70c0b1295
8aef4326-0c57-4ec6-954a-97eb2a3fc352	6000	a97e9385-919f-407e-8068-39b64190e186	2025-03-23 03:13:17.911407+00	dc9ba10d-3b59-4b17-9610-fce7faea0289
8aef4326-0c57-4ec6-954a-97eb2a3fc352	8000	c6846a16-e8b0-48c0-b2f9-cf859d693b88	2025-03-23 03:13:17.911407+00	2e234133-efcb-4b73-8e21-824790789859
8aef4326-0c57-4ec6-954a-97eb2a3fc352	12000	8ded86c4-045b-478f-888f-b04dc91f6c60	2025-03-23 03:13:17.911407+00	66f242ad-cd8d-42d0-b5c9-37e4588591cb
f8475c7a-868a-4a99-9acf-6756f0924e58	4000	0b3e5a83-32b8-485d-a8d2-f20f40f104b3	2025-03-23 03:13:17.911407+00	dc9ba10d-3b59-4b17-9610-fce7faea0289
f8475c7a-868a-4a99-9acf-6756f0924e58	6000	24827d3f-f5d5-4663-8dc3-2a84da179994	2025-03-23 03:13:17.911407+00	2e234133-efcb-4b73-8e21-824790789859
f8475c7a-868a-4a99-9acf-6756f0924e58	8000	486ce05c-969e-42af-a688-2ea12dfdbc53	2025-03-23 03:13:17.911407+00	66f242ad-cd8d-42d0-b5c9-37e4588591cb
2ad0f7ed-e42a-4228-a5b0-fff08ee452df	20000	ff9f3d8d-a1ca-4474-9077-f81749bf17b2	2025-03-23 03:13:17.911407+00	dc9ba10d-3b59-4b17-9610-fce7faea0289
2ad0f7ed-e42a-4228-a5b0-fff08ee452df	25000	7e727b17-1955-4e6e-80af-e7a395189af6	2025-03-23 03:13:17.911407+00	2e234133-efcb-4b73-8e21-824790789859
2ad0f7ed-e42a-4228-a5b0-fff08ee452df	30000	994e99ef-cc1b-49e6-a4a5-a979e4be0523	2025-03-23 03:13:17.911407+00	66f242ad-cd8d-42d0-b5c9-37e4588591cb
4933df24-0865-49eb-a89c-14484cdac00f	30000	93499938-9de3-4fe4-b8d8-1c3e4bcfa789	2025-03-23 03:13:17.911407+00	dc9ba10d-3b59-4b17-9610-fce7faea0289
4933df24-0865-49eb-a89c-14484cdac00f	20000	2cab6d63-fe9e-44aa-9c9b-8e754f9ceb02	2025-03-23 03:13:17.911407+00	2e234133-efcb-4b73-8e21-824790789859
4933df24-0865-49eb-a89c-14484cdac00f	10000	2d0cd2eb-1aa9-45b5-9a62-302e61335c5e	2025-03-23 03:13:17.911407+00	66f242ad-cd8d-42d0-b5c9-37e4588591cb
2e3755d8-d524-461f-bc1e-1047d13b5943	5000	e118a286-ed0b-42ff-a9b1-e10510df88fc	2025-03-23 03:13:17.911407+00	dc9ba10d-3b59-4b17-9610-fce7faea0289
2e3755d8-d524-461f-bc1e-1047d13b5943	10000	c79da192-a75a-4ddc-a378-078b6da372f0	2025-03-23 03:13:17.911407+00	2e234133-efcb-4b73-8e21-824790789859
2e3755d8-d524-461f-bc1e-1047d13b5943	15000	04d303fd-708c-496c-8547-bcec3f00fc78	2025-03-23 03:13:17.911407+00	66f242ad-cd8d-42d0-b5c9-37e4588591cb
17693149-4d1c-4eb3-befa-38f941444a88	5000	6620e8f2-32cc-4d45-8c98-5ef4dfda07fd	2025-03-23 03:13:17.911407+00	dc9ba10d-3b59-4b17-9610-fce7faea0289
17693149-4d1c-4eb3-befa-38f941444a88	10000	84bc8099-0acf-4ef3-94e5-c788dedccc50	2025-03-23 03:13:17.911407+00	2e234133-efcb-4b73-8e21-824790789859
17693149-4d1c-4eb3-befa-38f941444a88	15000	1b13503f-1205-4ce0-ba9b-7f41083c6cef	2025-03-23 03:13:17.911407+00	66f242ad-cd8d-42d0-b5c9-37e4588591cb
8b5bf2dc-0eca-4f0c-884f-a8a12f8d61d7	6000	03a6e3c5-0f7d-4e6f-9612-c89d6a4574b7	2025-03-23 04:02:29.701547+00	7c0742d0-524a-4dee-b994-10a0bbaf1b68
8b5bf2dc-0eca-4f0c-884f-a8a12f8d61d7	8000	b672a3bd-ed42-4070-8a69-c1f21010f82c	2025-03-23 04:02:29.701547+00	e2747c95-1d1e-4f3e-be7f-347c3fd76835
8b5bf2dc-0eca-4f0c-884f-a8a12f8d61d7	12000	1a64cfd3-936a-4512-9dfe-f78a67b4eafb	2025-03-23 04:02:29.701547+00	5455bcd1-904a-4f20-bddf-9de779dd2d1e
58d0ea44-61c0-4b85-b522-073be2ed4afc	4000	8ba2d506-1409-447f-9261-a2ef31a61dfe	2025-03-23 04:02:29.701547+00	7c0742d0-524a-4dee-b994-10a0bbaf1b68
58d0ea44-61c0-4b85-b522-073be2ed4afc	6000	841cc309-8feb-4f69-8bf0-1e8634cb21ce	2025-03-23 04:02:29.701547+00	e2747c95-1d1e-4f3e-be7f-347c3fd76835
58d0ea44-61c0-4b85-b522-073be2ed4afc	8000	33305945-9553-4a43-a9e7-df59f0c665d6	2025-03-23 04:02:29.701547+00	5455bcd1-904a-4f20-bddf-9de779dd2d1e
a12eda9a-a08d-4508-a2d2-9446ed64ba7e	20000	b2804e41-7111-494e-a9ad-b4110725acc0	2025-03-23 04:02:29.701547+00	7c0742d0-524a-4dee-b994-10a0bbaf1b68
a12eda9a-a08d-4508-a2d2-9446ed64ba7e	25000	40ecc265-3233-4bb0-b3de-2f32d8c7c3c7	2025-03-23 04:02:29.701547+00	e2747c95-1d1e-4f3e-be7f-347c3fd76835
a12eda9a-a08d-4508-a2d2-9446ed64ba7e	30000	240f45df-f42e-4a10-897a-a223f8224d37	2025-03-23 04:02:29.701547+00	5455bcd1-904a-4f20-bddf-9de779dd2d1e
95a06c55-3ca4-4a8b-8970-a78c72e38793	30000	b6eb7d36-ffe7-4b8c-a4a0-53100530a8b4	2025-03-23 04:02:29.701547+00	7c0742d0-524a-4dee-b994-10a0bbaf1b68
95a06c55-3ca4-4a8b-8970-a78c72e38793	20000	3c0d8c49-ef5a-4839-9d53-f5ec2e3b7875	2025-03-23 04:02:29.701547+00	e2747c95-1d1e-4f3e-be7f-347c3fd76835
95a06c55-3ca4-4a8b-8970-a78c72e38793	10000	692ec9fd-cb4e-4359-942d-a501eacfbd3d	2025-03-23 04:02:29.701547+00	5455bcd1-904a-4f20-bddf-9de779dd2d1e
56b96f48-efcc-4046-b6a4-adc6c6674b9f	5000	c9bb0aff-752a-4496-9707-ec75b35a67a8	2025-03-23 04:02:29.701547+00	7c0742d0-524a-4dee-b994-10a0bbaf1b68
56b96f48-efcc-4046-b6a4-adc6c6674b9f	10000	c45beebf-6e10-4bae-9ab4-8a81d9ace6da	2025-03-23 04:02:29.701547+00	e2747c95-1d1e-4f3e-be7f-347c3fd76835
56b96f48-efcc-4046-b6a4-adc6c6674b9f	15000	93275f52-082d-424b-9a96-def23413add2	2025-03-23 04:02:29.701547+00	5455bcd1-904a-4f20-bddf-9de779dd2d1e
3b4e6dce-84d2-4180-b160-e29174bcccbc	5000	366b91bb-3fa0-4b5d-b877-d45f4fe688a3	2025-03-23 04:02:29.701547+00	7c0742d0-524a-4dee-b994-10a0bbaf1b68
3b4e6dce-84d2-4180-b160-e29174bcccbc	10000	e5b2619d-458b-45a8-a5c3-e91120128bad	2025-03-23 04:02:29.701547+00	e2747c95-1d1e-4f3e-be7f-347c3fd76835
3b4e6dce-84d2-4180-b160-e29174bcccbc	15000	a7b8bf5e-5568-466d-b014-35e035f97711	2025-03-23 04:02:29.701547+00	5455bcd1-904a-4f20-bddf-9de779dd2d1e
5a849234-30a5-457d-b788-b4bd17981bf8	6000	7cd06334-cfd9-4691-8c27-0276eacfe4a5	2025-04-06 02:10:23.405726+00	ee54537a-db8c-4e21-a25c-12aa25f9c530
5a849234-30a5-457d-b788-b4bd17981bf8	8000	56448bb2-e426-44f8-83ab-eee3db003749	2025-04-06 02:10:23.405726+00	609da926-00d1-4029-80df-cb2a193341ed
5a849234-30a5-457d-b788-b4bd17981bf8	12000	4c6dc963-560e-4f17-96d1-ef2a7a1d62d9	2025-04-06 02:10:23.405726+00	4677c5f9-0457-4e65-b431-a83b1cfe6b35
e5b517bf-c631-4b1e-b386-746ccaa32f5c	4000	61eaeb9a-6f73-4cd7-a9d5-fe2721214635	2025-04-06 02:10:23.405726+00	ee54537a-db8c-4e21-a25c-12aa25f9c530
e5b517bf-c631-4b1e-b386-746ccaa32f5c	6000	b56844f1-e260-4cee-b98c-b84d53022f13	2025-04-06 02:10:23.405726+00	609da926-00d1-4029-80df-cb2a193341ed
e5b517bf-c631-4b1e-b386-746ccaa32f5c	8000	5be40252-7a8a-4365-80b2-f173018805e9	2025-04-06 02:10:23.405726+00	4677c5f9-0457-4e65-b431-a83b1cfe6b35
ba344ce6-172f-427f-84d4-7b436fdc9a9e	20000	5d302a53-4064-4016-8a0e-986e52b4211d	2025-04-06 02:10:23.405726+00	ee54537a-db8c-4e21-a25c-12aa25f9c530
ba344ce6-172f-427f-84d4-7b436fdc9a9e	25000	1287f96e-e0f8-4fb1-9689-beb0c38c0448	2025-04-06 02:10:23.405726+00	609da926-00d1-4029-80df-cb2a193341ed
ba344ce6-172f-427f-84d4-7b436fdc9a9e	30000	a0681180-4a89-4212-9608-e18418c8645f	2025-04-06 02:10:23.405726+00	4677c5f9-0457-4e65-b431-a83b1cfe6b35
866ee5fe-80b1-4b43-ae2b-7103b0f0e892	30000	ed9eaa56-c111-4994-b734-db4fc10dbfc9	2025-04-06 02:10:23.405726+00	ee54537a-db8c-4e21-a25c-12aa25f9c530
866ee5fe-80b1-4b43-ae2b-7103b0f0e892	20000	9af211d0-2ee6-476b-a988-30415eddb688	2025-04-06 02:10:23.405726+00	609da926-00d1-4029-80df-cb2a193341ed
866ee5fe-80b1-4b43-ae2b-7103b0f0e892	10000	699ef2d6-2a9f-4e7f-af8a-5b84d790cbd7	2025-04-06 02:10:23.405726+00	4677c5f9-0457-4e65-b431-a83b1cfe6b35
3b93db64-46c0-4772-b951-2449cb26b227	5000	39161c6d-88dd-452e-9762-e45896aec3e0	2025-04-06 02:10:23.405726+00	ee54537a-db8c-4e21-a25c-12aa25f9c530
3b93db64-46c0-4772-b951-2449cb26b227	10000	f5586247-6bfa-4045-907e-1117fea09484	2025-04-06 02:10:23.405726+00	609da926-00d1-4029-80df-cb2a193341ed
3b93db64-46c0-4772-b951-2449cb26b227	15000	2170cf79-814f-455f-ba14-9aa7c5d2712b	2025-04-06 02:10:23.405726+00	4677c5f9-0457-4e65-b431-a83b1cfe6b35
2023f099-6ca8-43bf-850c-7d08c9759cb4	5000	514de49e-d4f1-448e-a97a-b4efb1444c6e	2025-04-06 02:10:23.405726+00	ee54537a-db8c-4e21-a25c-12aa25f9c530
2023f099-6ca8-43bf-850c-7d08c9759cb4	10000	d2790ea0-6e58-4d9b-8cc7-a557b10e843b	2025-04-06 02:10:23.405726+00	609da926-00d1-4029-80df-cb2a193341ed
2023f099-6ca8-43bf-850c-7d08c9759cb4	15000	9fcb8c3f-1c10-4ce7-a668-98f62b2cddf4	2025-04-06 02:10:23.405726+00	4677c5f9-0457-4e65-b431-a83b1cfe6b35
8d4e3ed7-351c-4453-8fc2-79ac0b79ad9a	6000	ff563489-48ae-4396-873d-bf228cd09e2f	2025-04-13 10:21:02.546568+00	29193676-6d77-401f-8e7e-6cda6a19db4c
8d4e3ed7-351c-4453-8fc2-79ac0b79ad9a	8000	886fbc56-97c7-442c-b6d2-2c977dfd1d70	2025-04-13 10:21:02.546568+00	16ee9718-dcfd-4218-a05d-d1a27c288ee0
8d4e3ed7-351c-4453-8fc2-79ac0b79ad9a	12000	4773d0e9-f0db-4848-bf01-85fa4f06737b	2025-04-13 10:21:02.546568+00	250eb0f7-9cef-415c-8cfd-3750910c4475
a8174ca4-afc6-4b47-af24-7b36ee61c5b3	4000	9f253169-5474-4fcf-bbea-973d0540cc0c	2025-04-13 10:21:02.546568+00	29193676-6d77-401f-8e7e-6cda6a19db4c
a8174ca4-afc6-4b47-af24-7b36ee61c5b3	6000	41e280b9-d85c-407b-b112-57435209006c	2025-04-13 10:21:02.546568+00	16ee9718-dcfd-4218-a05d-d1a27c288ee0
a8174ca4-afc6-4b47-af24-7b36ee61c5b3	8000	6c1baaa5-db66-4d3a-9af4-43c8cdad14ce	2025-04-13 10:21:02.546568+00	250eb0f7-9cef-415c-8cfd-3750910c4475
c49671f7-7049-48f7-b80a-f4e919a5b1ce	20000	8ca61b42-f8c6-4990-8144-89acc9ca4f70	2025-04-13 10:21:02.546568+00	29193676-6d77-401f-8e7e-6cda6a19db4c
c49671f7-7049-48f7-b80a-f4e919a5b1ce	25000	71cb801a-debf-44bf-ad7d-fba68faf81a2	2025-04-13 10:21:02.546568+00	16ee9718-dcfd-4218-a05d-d1a27c288ee0
c49671f7-7049-48f7-b80a-f4e919a5b1ce	30000	01981cf1-6ce8-4555-8a13-323e00ab9d76	2025-04-13 10:21:02.546568+00	250eb0f7-9cef-415c-8cfd-3750910c4475
d9613ec9-8107-42eb-a872-8df47b415805	30000	e1fe1b2c-36b2-4205-a611-9fc92e83b918	2025-04-13 10:21:02.546568+00	29193676-6d77-401f-8e7e-6cda6a19db4c
d9613ec9-8107-42eb-a872-8df47b415805	20000	1a4c1344-d24f-4c4c-8561-e89afe6d84c9	2025-04-13 10:21:02.546568+00	16ee9718-dcfd-4218-a05d-d1a27c288ee0
d9613ec9-8107-42eb-a872-8df47b415805	10000	d6288341-6bc4-4d33-a199-0ce39b17ffb0	2025-04-13 10:21:02.546568+00	250eb0f7-9cef-415c-8cfd-3750910c4475
927b5cd7-2ae4-4264-a275-975e755cdc6b	5000	e2b9471d-e411-428a-a768-4403cef78e21	2025-04-13 10:21:02.546568+00	29193676-6d77-401f-8e7e-6cda6a19db4c
927b5cd7-2ae4-4264-a275-975e755cdc6b	10000	13f88edb-e49a-48c6-b6d7-22e44c613471	2025-04-13 10:21:02.546568+00	16ee9718-dcfd-4218-a05d-d1a27c288ee0
927b5cd7-2ae4-4264-a275-975e755cdc6b	15000	932b076c-9ddf-4855-9226-53090d860201	2025-04-13 10:21:02.546568+00	250eb0f7-9cef-415c-8cfd-3750910c4475
5c15aba7-9efc-40a9-85bd-506fdb84e14d	5000	f96964c7-932a-4de2-baa7-8008005baa07	2025-04-13 10:21:02.546568+00	29193676-6d77-401f-8e7e-6cda6a19db4c
5c15aba7-9efc-40a9-85bd-506fdb84e14d	10000	c0150d23-957a-4d8d-98ef-e2fb52e937e2	2025-04-13 10:21:02.546568+00	16ee9718-dcfd-4218-a05d-d1a27c288ee0
5c15aba7-9efc-40a9-85bd-506fdb84e14d	15000	be7c8928-bcbc-452c-9120-be46d9a80b0f	2025-04-13 10:21:02.546568+00	250eb0f7-9cef-415c-8cfd-3750910c4475
2910e48e-2e95-4552-badc-b2809512d2c5	30000	adf77403-bb5d-4f8d-a1f7-023ca44d62cc	2025-04-20 03:36:44.016718+00	aa6a638c-46f2-4abe-8717-e63e5c8c7713
2c1ae9db-3262-461a-8543-028ca9a114fc	6000	8bb7d4e4-8354-4a40-831c-2869a37a7464	2025-04-27 12:39:10.229862+00	5cc1d81b-b4c1-4698-8f9e-d062eeab2f80
2c1ae9db-3262-461a-8543-028ca9a114fc	8000	02cdbd7e-a4a5-49b1-b19a-2ea12c3b646c	2025-04-27 12:39:10.229862+00	64b0e1e8-a7ad-40aa-acb4-92229588182e
2c1ae9db-3262-461a-8543-028ca9a114fc	12000	58d33131-3a7f-4992-ad76-1ae39d43ca27	2025-04-27 12:39:10.229862+00	fc3d1971-208a-47b7-bcf5-d1625c830014
f9799abd-45b3-48dc-a781-7c06d5539182	4000	120c068d-e923-489e-8fa8-e1f476197114	2025-04-27 12:39:10.229862+00	5cc1d81b-b4c1-4698-8f9e-d062eeab2f80
f9799abd-45b3-48dc-a781-7c06d5539182	6000	019b41ea-f670-431e-a6ec-e864e45f0fc6	2025-04-27 12:39:10.229862+00	64b0e1e8-a7ad-40aa-acb4-92229588182e
f9799abd-45b3-48dc-a781-7c06d5539182	8000	eb3f0c72-0aab-4348-b63c-afa3776faaf3	2025-04-27 12:39:10.229862+00	fc3d1971-208a-47b7-bcf5-d1625c830014
51f611e7-af3e-4c61-8aab-1f67448e6f68	20000	777801d3-b887-49f0-a023-04bc6469df49	2025-04-27 12:39:10.229862+00	5cc1d81b-b4c1-4698-8f9e-d062eeab2f80
51f611e7-af3e-4c61-8aab-1f67448e6f68	25000	8bd9a475-2796-4ef7-8c26-ea0e7153c377	2025-04-27 12:39:10.229862+00	64b0e1e8-a7ad-40aa-acb4-92229588182e
51f611e7-af3e-4c61-8aab-1f67448e6f68	30000	7b53b389-3ed9-4e81-b484-5696da8f315f	2025-04-27 12:39:10.229862+00	fc3d1971-208a-47b7-bcf5-d1625c830014
9288f044-5d19-4ffb-9a0f-86fe5d93c71e	30000	5214c314-9a68-478d-abfb-e485153817d1	2025-04-27 12:39:10.229862+00	5cc1d81b-b4c1-4698-8f9e-d062eeab2f80
9288f044-5d19-4ffb-9a0f-86fe5d93c71e	20000	86e1b0ee-977c-44ee-8bc1-3ca15be0d1d8	2025-04-27 12:39:10.229862+00	64b0e1e8-a7ad-40aa-acb4-92229588182e
9288f044-5d19-4ffb-9a0f-86fe5d93c71e	10000	86a79337-38df-456e-aaf8-bb05174cf4a3	2025-04-27 12:39:10.229862+00	fc3d1971-208a-47b7-bcf5-d1625c830014
f7ead5a3-1574-4439-a4a4-c400dd50aa6e	5000	5a5443a8-a979-4cc5-adef-99b9c31a879e	2025-04-27 12:39:10.229862+00	5cc1d81b-b4c1-4698-8f9e-d062eeab2f80
f7ead5a3-1574-4439-a4a4-c400dd50aa6e	10000	e8421fe5-e1cc-4f3b-ab87-345a3058ad75	2025-04-27 12:39:10.229862+00	64b0e1e8-a7ad-40aa-acb4-92229588182e
f7ead5a3-1574-4439-a4a4-c400dd50aa6e	15000	dfe52aa0-ebed-4a16-bedc-8d82648c5aa7	2025-04-27 12:39:10.229862+00	fc3d1971-208a-47b7-bcf5-d1625c830014
88093b9e-b6f4-4e83-b3cd-f37377812a4a	5000	0c4fab2a-c02a-4db8-be31-28ef2da1585c	2025-04-27 12:39:10.229862+00	5cc1d81b-b4c1-4698-8f9e-d062eeab2f80
88093b9e-b6f4-4e83-b3cd-f37377812a4a	10000	e21c80a5-eb8d-43ed-a9b2-a07cf30fb5cb	2025-04-27 12:39:10.229862+00	64b0e1e8-a7ad-40aa-acb4-92229588182e
88093b9e-b6f4-4e83-b3cd-f37377812a4a	15000	be5a73fe-1c79-40a7-8770-ad8b40359586	2025-04-27 12:39:10.229862+00	fc3d1971-208a-47b7-bcf5-d1625c830014
31ab0b7a-2fb0-418a-a521-eccffbecbdcb	6000	75f5d763-45cf-4ff8-8de1-3f7a03a170cc	2025-04-27 12:44:34.319161+00	1faff574-7239-4ac8-a923-31788aaa6452
31ab0b7a-2fb0-418a-a521-eccffbecbdcb	8000	3d58f79d-13c0-47a3-9810-7a8cd8403635	2025-04-27 12:44:34.319161+00	a94697a3-f60c-4a5e-bd35-ea92332a1f25
31ab0b7a-2fb0-418a-a521-eccffbecbdcb	12000	74d8209a-0211-4ce1-a5ee-cf57cf815a85	2025-04-27 12:44:34.319161+00	8106b781-3811-457d-92c5-69b05916d3c1
c0e756d2-8a46-45ad-b546-531ce0f34b24	4000	91b42124-f9c1-430e-ac81-cb690eba5d13	2025-04-27 12:44:34.319161+00	1faff574-7239-4ac8-a923-31788aaa6452
c0e756d2-8a46-45ad-b546-531ce0f34b24	6000	5e02edac-60ef-4f8a-aab6-2f565946e1a8	2025-04-27 12:44:34.319161+00	a94697a3-f60c-4a5e-bd35-ea92332a1f25
c0e756d2-8a46-45ad-b546-531ce0f34b24	8000	6d1f695d-bf60-42e2-9016-c9852e5f9d49	2025-04-27 12:44:34.319161+00	8106b781-3811-457d-92c5-69b05916d3c1
af5b8af7-f532-4220-8e60-d59541db622c	20000	b2c23b6b-b4cd-429a-be0b-60fa2196e23b	2025-04-27 12:44:34.319161+00	1faff574-7239-4ac8-a923-31788aaa6452
af5b8af7-f532-4220-8e60-d59541db622c	25000	ee16b197-2e68-4f3f-b7ba-2ac7f53ffc88	2025-04-27 12:44:34.319161+00	a94697a3-f60c-4a5e-bd35-ea92332a1f25
af5b8af7-f532-4220-8e60-d59541db622c	30000	c7bb8b58-1eb5-40df-9549-59132e03a6bf	2025-04-27 12:44:34.319161+00	8106b781-3811-457d-92c5-69b05916d3c1
baf9f542-e191-4bc6-9928-90ccb94fc860	30000	547a97df-b447-4045-9fab-a3ff6d2691c0	2025-04-27 12:44:34.319161+00	1faff574-7239-4ac8-a923-31788aaa6452
baf9f542-e191-4bc6-9928-90ccb94fc860	20000	77c22cd0-be8f-4d3b-8cf0-a313744a216b	2025-04-27 12:44:34.319161+00	a94697a3-f60c-4a5e-bd35-ea92332a1f25
baf9f542-e191-4bc6-9928-90ccb94fc860	10000	f2a235bd-8883-4dc3-9254-2ed3b2d3f05a	2025-04-27 12:44:34.319161+00	8106b781-3811-457d-92c5-69b05916d3c1
6bbcfa67-23f6-45de-883a-f7d85eed08f6	5000	2d65c01b-d6eb-4815-beb1-4223c08f8a48	2025-04-27 12:44:34.319161+00	1faff574-7239-4ac8-a923-31788aaa6452
6bbcfa67-23f6-45de-883a-f7d85eed08f6	10000	aa93099a-b1e8-4cfa-b484-008eaac84517	2025-04-27 12:44:34.319161+00	a94697a3-f60c-4a5e-bd35-ea92332a1f25
6bbcfa67-23f6-45de-883a-f7d85eed08f6	15000	d2550123-e624-4998-814f-88a281f7045f	2025-04-27 12:44:34.319161+00	8106b781-3811-457d-92c5-69b05916d3c1
f370b869-9338-436f-8ba4-e52867475cca	5000	d9ef1e28-f05b-41ce-9e5a-bd147991f910	2025-04-27 12:44:34.319161+00	1faff574-7239-4ac8-a923-31788aaa6452
f370b869-9338-436f-8ba4-e52867475cca	10000	f0f1dd6e-494c-4af6-8cd6-ba4639f10026	2025-04-27 12:44:34.319161+00	a94697a3-f60c-4a5e-bd35-ea92332a1f25
f370b869-9338-436f-8ba4-e52867475cca	15000	8aa7a2d7-c5d1-433a-9073-a1a76243c4a8	2025-04-27 12:44:34.319161+00	8106b781-3811-457d-92c5-69b05916d3c1
a7265ca4-972f-4cfb-a680-156a8c20121c	6000	db6f9bea-51d6-4007-8038-c2b77c1f814e	2025-04-29 06:42:30.746304+00	cc695d2b-ad35-4632-a415-65bbde16ca70
a7265ca4-972f-4cfb-a680-156a8c20121c	8000	4164d56f-add3-4f0f-97fb-356e12233d6b	2025-04-29 06:42:30.746304+00	2df9477b-dd99-44a6-b7e7-ce7b061a1b9b
a7265ca4-972f-4cfb-a680-156a8c20121c	12000	5a84f557-341c-4776-865b-e5decc0cefd8	2025-04-29 06:42:30.746304+00	e9363e7e-41ae-4e0c-a21b-f48f821798f5
674c2171-e324-4069-97a3-5a0c4df463b9	4000	049799e0-911e-4e43-8988-d8da8f88961f	2025-04-29 06:42:30.746304+00	cc695d2b-ad35-4632-a415-65bbde16ca70
674c2171-e324-4069-97a3-5a0c4df463b9	6000	e8fa0de9-db04-4239-82c9-9366430f49d3	2025-04-29 06:42:30.746304+00	2df9477b-dd99-44a6-b7e7-ce7b061a1b9b
674c2171-e324-4069-97a3-5a0c4df463b9	8000	39a3f2b2-854b-44eb-a2b3-fc32088bb19c	2025-04-29 06:42:30.746304+00	e9363e7e-41ae-4e0c-a21b-f48f821798f5
a9bfc68c-1220-4834-9ca5-5c50de6abb6a	20000	8e8be753-3677-4aeb-9e46-814618662095	2025-04-29 06:42:30.746304+00	cc695d2b-ad35-4632-a415-65bbde16ca70
a9bfc68c-1220-4834-9ca5-5c50de6abb6a	25000	49f6cb64-6d44-4bba-bcdb-a72e4bc9dcc3	2025-04-29 06:42:30.746304+00	2df9477b-dd99-44a6-b7e7-ce7b061a1b9b
a9bfc68c-1220-4834-9ca5-5c50de6abb6a	30000	629dff02-a575-487e-8e30-6b02f5a27282	2025-04-29 06:42:30.746304+00	e9363e7e-41ae-4e0c-a21b-f48f821798f5
6ef02098-9db2-4488-9051-fa0328c0d3b7	30000	dddcee29-a994-4da5-bb5b-4fc33e40f213	2025-04-29 06:42:30.746304+00	cc695d2b-ad35-4632-a415-65bbde16ca70
6ef02098-9db2-4488-9051-fa0328c0d3b7	20000	d5777ccb-3088-46aa-98ed-a6491b678daf	2025-04-29 06:42:30.746304+00	2df9477b-dd99-44a6-b7e7-ce7b061a1b9b
6ef02098-9db2-4488-9051-fa0328c0d3b7	10000	208dfffc-a5dc-48fb-98fd-d687829b57a4	2025-04-29 06:42:30.746304+00	e9363e7e-41ae-4e0c-a21b-f48f821798f5
1c87ab0f-8c06-4e9a-b6a3-c9a7532e4352	5000	bb77a8d7-63c3-46ab-b1b1-6bdab9284315	2025-04-29 06:42:30.746304+00	cc695d2b-ad35-4632-a415-65bbde16ca70
1c87ab0f-8c06-4e9a-b6a3-c9a7532e4352	10000	6958b2ce-951b-463b-8aa8-972baf6100e1	2025-04-29 06:42:30.746304+00	2df9477b-dd99-44a6-b7e7-ce7b061a1b9b
1c87ab0f-8c06-4e9a-b6a3-c9a7532e4352	15000	bc14ea74-3f04-4405-bc7d-fe94510a94d9	2025-04-29 06:42:30.746304+00	e9363e7e-41ae-4e0c-a21b-f48f821798f5
fa687718-04a9-4d70-bd36-6994c008f814	5000	e874bebc-7eef-4107-9e58-20e8364dc4ee	2025-04-29 06:42:30.746304+00	cc695d2b-ad35-4632-a415-65bbde16ca70
fa687718-04a9-4d70-bd36-6994c008f814	10000	7d83697f-993b-41d9-be5f-761100a25b32	2025-04-29 06:42:30.746304+00	2df9477b-dd99-44a6-b7e7-ce7b061a1b9b
fa687718-04a9-4d70-bd36-6994c008f814	15000	4aef31f6-96c5-4158-91c2-1a49eca385f1	2025-04-29 06:42:30.746304+00	e9363e7e-41ae-4e0c-a21b-f48f821798f5
ea8e0e0b-53f1-4ac3-8b74-866ae12874e4	6000	b4b03806-3d7c-4684-bf27-8c0d84193484	2025-05-01 14:30:59.616206+00	1e2ac3b8-37cf-4a04-9120-ed3080f31c67
ea8e0e0b-53f1-4ac3-8b74-866ae12874e4	8000	c5caffeb-5eba-4dc8-b2e6-5a876f208409	2025-05-01 14:30:59.616206+00	6c25d1d5-277d-4ac0-b46a-57325e6b6580
ea8e0e0b-53f1-4ac3-8b74-866ae12874e4	12000	c5faab99-1e50-4303-92a0-e2d2f12461e8	2025-05-01 14:30:59.616206+00	5ddf6e81-eb80-4e38-8a98-a49508d21ba0
a250ac37-e919-4708-85ac-77eef8be077c	4000	72bcc074-a9b4-4964-8ef4-f9a0a76e3ed3	2025-05-01 14:30:59.616206+00	1e2ac3b8-37cf-4a04-9120-ed3080f31c67
a250ac37-e919-4708-85ac-77eef8be077c	6000	460e9a01-4c66-45f7-8211-491307c82688	2025-05-01 14:30:59.616206+00	6c25d1d5-277d-4ac0-b46a-57325e6b6580
a250ac37-e919-4708-85ac-77eef8be077c	8000	705e870f-3ebc-4cc7-95e2-3deed5605566	2025-05-01 14:30:59.616206+00	5ddf6e81-eb80-4e38-8a98-a49508d21ba0
2974d905-74f3-4217-ba00-aba97d091019	20000	367811ee-7989-4afb-a4b9-e9a104fb1365	2025-05-01 14:30:59.616206+00	1e2ac3b8-37cf-4a04-9120-ed3080f31c67
2974d905-74f3-4217-ba00-aba97d091019	25000	679e3774-ebf3-4ecc-bddc-a831df263783	2025-05-01 14:30:59.616206+00	6c25d1d5-277d-4ac0-b46a-57325e6b6580
2974d905-74f3-4217-ba00-aba97d091019	30000	d190c6d9-60ba-4af7-999f-700907600e1c	2025-05-01 14:30:59.616206+00	5ddf6e81-eb80-4e38-8a98-a49508d21ba0
27998903-88ba-4a9d-b233-7bdd4cb476db	30000	dcf7f237-2204-4178-b425-9eba2c9b0d2e	2025-05-01 14:30:59.616206+00	1e2ac3b8-37cf-4a04-9120-ed3080f31c67
27998903-88ba-4a9d-b233-7bdd4cb476db	20000	1a86a21a-f187-4b05-a106-7164554b2de7	2025-05-01 14:30:59.616206+00	6c25d1d5-277d-4ac0-b46a-57325e6b6580
27998903-88ba-4a9d-b233-7bdd4cb476db	10000	a5c6ae46-7688-4754-a368-cfeeedb8171e	2025-05-01 14:30:59.616206+00	5ddf6e81-eb80-4e38-8a98-a49508d21ba0
761b6400-61dc-4fd3-b1a5-70efa2eb8afa	5000	77608528-086a-439a-8293-dfd31d90f33c	2025-05-01 14:30:59.616206+00	1e2ac3b8-37cf-4a04-9120-ed3080f31c67
761b6400-61dc-4fd3-b1a5-70efa2eb8afa	10000	e835ce0f-3799-4caa-9f46-7bdd819d9126	2025-05-01 14:30:59.616206+00	6c25d1d5-277d-4ac0-b46a-57325e6b6580
761b6400-61dc-4fd3-b1a5-70efa2eb8afa	15000	9807c301-0ef1-4568-a529-018b05b3338e	2025-05-01 14:30:59.616206+00	5ddf6e81-eb80-4e38-8a98-a49508d21ba0
035f9073-af4e-4a1d-bebd-cc0a6cc98e84	5000	5e154bef-b2b8-4b6d-b47e-9cab80da8bf3	2025-05-01 14:30:59.616206+00	1e2ac3b8-37cf-4a04-9120-ed3080f31c67
035f9073-af4e-4a1d-bebd-cc0a6cc98e84	10000	13d9c4bf-437d-44d8-8139-83da05e9a91f	2025-05-01 14:30:59.616206+00	6c25d1d5-277d-4ac0-b46a-57325e6b6580
035f9073-af4e-4a1d-bebd-cc0a6cc98e84	15000	2b1b8050-ba3d-47cc-a51d-07b20865dd35	2025-05-01 14:30:59.616206+00	5ddf6e81-eb80-4e38-8a98-a49508d21ba0
bdddf168-4650-4bc0-87cd-b2fb8b037af6	6000	76dca865-1db5-4bb0-839d-2f2396895998	2025-05-01 14:42:42.602641+00	179c3255-8ad1-4cb7-8414-686014f1547b
bdddf168-4650-4bc0-87cd-b2fb8b037af6	8000	c35f826d-5af6-466b-b2ca-510a3b529dc0	2025-05-01 14:42:42.602641+00	17f23519-e029-43bc-a8c2-1ea75c6217a7
bdddf168-4650-4bc0-87cd-b2fb8b037af6	12000	5a698b85-51ce-4636-a40d-31759c030644	2025-05-01 14:42:42.602641+00	53f467de-a833-4896-a91d-03532318d63d
30934528-6a17-4eb2-aa2a-03bec5f7ca50	4000	371efbec-a9e1-4363-bce1-c9abc78ec475	2025-05-01 14:42:42.602641+00	179c3255-8ad1-4cb7-8414-686014f1547b
30934528-6a17-4eb2-aa2a-03bec5f7ca50	6000	35d8d4da-9ed3-4a82-86c2-a1a12f67aec4	2025-05-01 14:42:42.602641+00	17f23519-e029-43bc-a8c2-1ea75c6217a7
30934528-6a17-4eb2-aa2a-03bec5f7ca50	8000	f559257f-6d53-40d9-9241-056dae876ee2	2025-05-01 14:42:42.602641+00	53f467de-a833-4896-a91d-03532318d63d
d34d73dc-1773-4ca9-865b-ded8ad76a388	20000	1202b715-2f45-45d6-9dc3-be3ef8a53f72	2025-05-01 14:42:42.602641+00	179c3255-8ad1-4cb7-8414-686014f1547b
d34d73dc-1773-4ca9-865b-ded8ad76a388	25000	ff940cf3-dde0-4908-be7e-dc59a4e651ab	2025-05-01 14:42:42.602641+00	17f23519-e029-43bc-a8c2-1ea75c6217a7
d34d73dc-1773-4ca9-865b-ded8ad76a388	30000	849d0810-360d-485d-9a70-c3f9031ab11a	2025-05-01 14:42:42.602641+00	53f467de-a833-4896-a91d-03532318d63d
2f72ef2d-ef36-4cd2-9f12-ca36899d36d3	30000	f6ffc200-86ff-481d-b981-8eb5b386f863	2025-05-01 14:42:42.602641+00	179c3255-8ad1-4cb7-8414-686014f1547b
2f72ef2d-ef36-4cd2-9f12-ca36899d36d3	20000	4d75ed8e-3a97-4e14-b6fe-56b779882d74	2025-05-01 14:42:42.602641+00	17f23519-e029-43bc-a8c2-1ea75c6217a7
2f72ef2d-ef36-4cd2-9f12-ca36899d36d3	10000	842bc8cf-4ef2-49e6-94e9-33e9481b9eeb	2025-05-01 14:42:42.602641+00	53f467de-a833-4896-a91d-03532318d63d
0bbb46ad-1ce3-49c0-8e95-a64f064be09f	5000	b00fdd29-5202-4591-85a5-cd7a96d66704	2025-05-01 14:42:42.602641+00	179c3255-8ad1-4cb7-8414-686014f1547b
0bbb46ad-1ce3-49c0-8e95-a64f064be09f	10000	faa51585-4ab7-401a-97d1-c83fbea3696e	2025-05-01 14:42:42.602641+00	17f23519-e029-43bc-a8c2-1ea75c6217a7
0bbb46ad-1ce3-49c0-8e95-a64f064be09f	15000	5f6e766d-fb75-4d09-8e5e-393aeab4aea4	2025-05-01 14:42:42.602641+00	53f467de-a833-4896-a91d-03532318d63d
0b9e1e68-3477-4801-b43b-4b0651d080da	5000	929858e1-5592-4779-b0b7-008112e360a6	2025-05-01 14:42:42.602641+00	179c3255-8ad1-4cb7-8414-686014f1547b
0b9e1e68-3477-4801-b43b-4b0651d080da	10000	e2b837c9-44de-493c-ad91-f73f792afba4	2025-05-01 14:42:42.602641+00	17f23519-e029-43bc-a8c2-1ea75c6217a7
0b9e1e68-3477-4801-b43b-4b0651d080da	15000	a5eed6c7-8ed2-4427-88b6-152bde7817f7	2025-05-01 14:42:42.602641+00	53f467de-a833-4896-a91d-03532318d63d
d7973deb-180b-438f-a451-1ea2ac8fb5c1	6000	193178dc-46c3-4140-b705-e3b0569843e1	2025-05-01 14:44:04.795594+00	5c42b913-6aa7-49e0-90ca-05525bb0ed3a
d7973deb-180b-438f-a451-1ea2ac8fb5c1	8000	4a0d0ee2-e715-4a84-b13c-5efdbcb41b82	2025-05-01 14:44:04.795594+00	286d5002-e006-4f55-96c9-25fecd5327e1
d7973deb-180b-438f-a451-1ea2ac8fb5c1	12000	64e8ce1d-ae5f-4075-87b2-96832e11d59e	2025-05-01 14:44:04.795594+00	fe7256ac-3d99-457c-b100-839e96aacc2e
60c2796e-e621-4103-a2d1-cb2faa03f47d	4000	13d932e4-ddca-4a4d-9ccb-90d8a87e3b7d	2025-05-01 14:44:04.795594+00	5c42b913-6aa7-49e0-90ca-05525bb0ed3a
60c2796e-e621-4103-a2d1-cb2faa03f47d	6000	f3831f7e-e1dd-4ffe-9904-db3105dd5644	2025-05-01 14:44:04.795594+00	286d5002-e006-4f55-96c9-25fecd5327e1
60c2796e-e621-4103-a2d1-cb2faa03f47d	8000	c8c428e4-6f8d-4b19-98e9-287ca50481de	2025-05-01 14:44:04.795594+00	fe7256ac-3d99-457c-b100-839e96aacc2e
4ec9d514-cee8-4155-ae6b-3b43ff53eea0	20000	f4f2a0fc-1604-4c1d-ad48-ef08ea30bab9	2025-05-01 14:44:04.795594+00	5c42b913-6aa7-49e0-90ca-05525bb0ed3a
4ec9d514-cee8-4155-ae6b-3b43ff53eea0	25000	b996b600-a512-4c28-9aa7-3b0e776343e2	2025-05-01 14:44:04.795594+00	286d5002-e006-4f55-96c9-25fecd5327e1
4ec9d514-cee8-4155-ae6b-3b43ff53eea0	30000	ca60116a-ed5e-4d4b-b63f-d7ca7b67d78b	2025-05-01 14:44:04.795594+00	fe7256ac-3d99-457c-b100-839e96aacc2e
21432e22-8af2-4acb-aed0-6d6c2e96b3a7	30000	1c6aa082-f7b4-4a58-a61a-a6d6fd43860b	2025-05-01 14:44:04.795594+00	5c42b913-6aa7-49e0-90ca-05525bb0ed3a
21432e22-8af2-4acb-aed0-6d6c2e96b3a7	20000	647737c7-50d4-4853-a75f-1837115a20a9	2025-05-01 14:44:04.795594+00	286d5002-e006-4f55-96c9-25fecd5327e1
21432e22-8af2-4acb-aed0-6d6c2e96b3a7	10000	40598d7f-3c81-405b-982b-98c581796b8b	2025-05-01 14:44:04.795594+00	fe7256ac-3d99-457c-b100-839e96aacc2e
f3c31070-7c3a-4197-95b1-e59a9aaa36c1	5000	1fc741fb-947a-4fb9-8c3b-7554657aec2d	2025-05-01 14:44:04.795594+00	5c42b913-6aa7-49e0-90ca-05525bb0ed3a
f3c31070-7c3a-4197-95b1-e59a9aaa36c1	10000	63a5fabd-00c7-48af-a02e-981d3dd98e7b	2025-05-01 14:44:04.795594+00	286d5002-e006-4f55-96c9-25fecd5327e1
f3c31070-7c3a-4197-95b1-e59a9aaa36c1	15000	fcd54369-661b-45e1-b2f2-1dbd5df35614	2025-05-01 14:44:04.795594+00	fe7256ac-3d99-457c-b100-839e96aacc2e
8900f2ad-aec8-4a7b-be57-d33cc5c90eb1	5000	d2ab2277-ffcf-46ac-85a2-418c76b00031	2025-05-01 14:44:04.795594+00	5c42b913-6aa7-49e0-90ca-05525bb0ed3a
8900f2ad-aec8-4a7b-be57-d33cc5c90eb1	10000	83cd5672-4a0b-492b-bebe-9e37e91c4d36	2025-05-01 14:44:04.795594+00	286d5002-e006-4f55-96c9-25fecd5327e1
8900f2ad-aec8-4a7b-be57-d33cc5c90eb1	15000	a91562f4-aac0-4f02-8abb-f90ffed7cbc4	2025-05-01 14:44:04.795594+00	fe7256ac-3d99-457c-b100-839e96aacc2e
02d33e9d-30cf-4ef6-8094-fa21cc6a1cd4	6000	d6775913-b62b-40ef-8f9e-288b93efa8a5	2025-05-01 14:44:44.123883+00	a0d3182c-b5f1-4162-a35e-18d89206cbed
02d33e9d-30cf-4ef6-8094-fa21cc6a1cd4	8000	fadfcca2-d457-45d7-b6a5-df91209babd5	2025-05-01 14:44:44.123883+00	7fb6c313-652d-40ec-b28d-d5823b591607
02d33e9d-30cf-4ef6-8094-fa21cc6a1cd4	12000	e0b98139-ed29-4ce9-9829-47fedd11738f	2025-05-01 14:44:44.123883+00	2238403b-11f9-481d-b773-9d38f9c49619
96be692b-edbc-4760-9404-291d0c8f2a74	4000	164a935a-a1d0-4302-9638-fcbd54ea9bf2	2025-05-01 14:44:44.123883+00	a0d3182c-b5f1-4162-a35e-18d89206cbed
96be692b-edbc-4760-9404-291d0c8f2a74	6000	07ae6240-a6e6-441a-a5e3-1c8f23b706b9	2025-05-01 14:44:44.123883+00	7fb6c313-652d-40ec-b28d-d5823b591607
96be692b-edbc-4760-9404-291d0c8f2a74	8000	68dec3fe-3ed8-488c-b0da-d0450f6939b2	2025-05-01 14:44:44.123883+00	2238403b-11f9-481d-b773-9d38f9c49619
1cba3994-4d1c-4792-a15d-589de4b820c7	20000	189baffa-5eaa-4669-9453-fa4943ed160d	2025-05-01 14:44:44.123883+00	a0d3182c-b5f1-4162-a35e-18d89206cbed
1cba3994-4d1c-4792-a15d-589de4b820c7	25000	b6b5a473-c4aa-46fe-ad26-147c7641b526	2025-05-01 14:44:44.123883+00	7fb6c313-652d-40ec-b28d-d5823b591607
1cba3994-4d1c-4792-a15d-589de4b820c7	30000	15fec180-c486-47e7-be39-bbf02e2a01d2	2025-05-01 14:44:44.123883+00	2238403b-11f9-481d-b773-9d38f9c49619
0794a308-c78b-4d23-a1d4-c80d2d781fc7	30000	39c1e497-ac29-471e-aa97-536f38bbdf42	2025-05-01 14:44:44.123883+00	a0d3182c-b5f1-4162-a35e-18d89206cbed
0794a308-c78b-4d23-a1d4-c80d2d781fc7	20000	aefc644d-90ff-460e-9b19-911fa6d618e0	2025-05-01 14:44:44.123883+00	7fb6c313-652d-40ec-b28d-d5823b591607
0794a308-c78b-4d23-a1d4-c80d2d781fc7	10000	768fff50-d256-466e-a802-065750eaf1ee	2025-05-01 14:44:44.123883+00	2238403b-11f9-481d-b773-9d38f9c49619
d83b98fe-b532-4c5f-bcfe-db59b962ac08	5000	9e3700ea-d5c5-4132-9384-b6a12703a919	2025-05-01 14:44:44.123883+00	a0d3182c-b5f1-4162-a35e-18d89206cbed
d83b98fe-b532-4c5f-bcfe-db59b962ac08	10000	d7569176-1bcf-4079-a15a-2b6cdd89cffc	2025-05-01 14:44:44.123883+00	7fb6c313-652d-40ec-b28d-d5823b591607
d83b98fe-b532-4c5f-bcfe-db59b962ac08	15000	00e5b259-9993-4aa9-bf75-e3df7b166b3f	2025-05-01 14:44:44.123883+00	2238403b-11f9-481d-b773-9d38f9c49619
506c9629-af12-401a-bfc3-ac702266a399	5000	83fdbb42-0788-493f-960e-3b6dd4f195d8	2025-05-01 14:44:44.123883+00	a0d3182c-b5f1-4162-a35e-18d89206cbed
506c9629-af12-401a-bfc3-ac702266a399	10000	caf8b7df-7d79-4d63-b5ef-c546e185ac0e	2025-05-01 14:44:44.123883+00	7fb6c313-652d-40ec-b28d-d5823b591607
506c9629-af12-401a-bfc3-ac702266a399	15000	2747fd0d-123d-4298-9e27-229b1bfd3e2d	2025-05-01 14:44:44.123883+00	2238403b-11f9-481d-b773-9d38f9c49619
f336b3cf-b4b7-4af3-8c03-9b012f275da7	6000	b5b0930b-d55a-4646-961d-b0213d9e41b0	2025-05-01 14:48:09.342027+00	28150363-d0b0-4636-a997-dfa79defc28e
f336b3cf-b4b7-4af3-8c03-9b012f275da7	8000	77e09b23-f975-4144-9891-af516429be3d	2025-05-01 14:48:09.342027+00	d0f9d176-b106-493a-afe2-7dfe45d8f605
f336b3cf-b4b7-4af3-8c03-9b012f275da7	12000	20c8a7aa-171e-4ec3-acde-1ce0a9ee45fe	2025-05-01 14:48:09.342027+00	3b628d15-2730-4750-9054-dca82c9dde6c
81fea502-9a08-4ec0-9476-c630da7d4635	4000	aa26708c-0623-456d-a5c0-5556bae715e8	2025-05-01 14:48:09.342027+00	28150363-d0b0-4636-a997-dfa79defc28e
81fea502-9a08-4ec0-9476-c630da7d4635	6000	7779b916-6452-4e77-8024-67669231192a	2025-05-01 14:48:09.342027+00	d0f9d176-b106-493a-afe2-7dfe45d8f605
81fea502-9a08-4ec0-9476-c630da7d4635	8000	cf8798e8-9296-49e1-9887-74ab1bd917f9	2025-05-01 14:48:09.342027+00	3b628d15-2730-4750-9054-dca82c9dde6c
f72504f7-0a83-44e3-9e83-efbcf0cf8c91	20000	acd7398f-2c57-478b-bb67-2d39d23a6be7	2025-05-01 14:48:09.342027+00	28150363-d0b0-4636-a997-dfa79defc28e
f72504f7-0a83-44e3-9e83-efbcf0cf8c91	25000	9b1f2e16-d9ab-4d8b-9394-d0ba8b012b84	2025-05-01 14:48:09.342027+00	d0f9d176-b106-493a-afe2-7dfe45d8f605
f72504f7-0a83-44e3-9e83-efbcf0cf8c91	30000	fa2cf83c-056d-4bd3-a179-ddee430f0f5b	2025-05-01 14:48:09.342027+00	3b628d15-2730-4750-9054-dca82c9dde6c
5c1ba802-9ea9-437d-bb7b-600ee83d4092	30000	555113af-cf05-417e-82f0-cb9ca58c4ac9	2025-05-01 14:48:09.342027+00	28150363-d0b0-4636-a997-dfa79defc28e
5c1ba802-9ea9-437d-bb7b-600ee83d4092	20000	32ff9b9d-8650-442e-b37f-9734b8b08d85	2025-05-01 14:48:09.342027+00	d0f9d176-b106-493a-afe2-7dfe45d8f605
5c1ba802-9ea9-437d-bb7b-600ee83d4092	10000	a87965dd-c4f4-415d-baed-7a6e12606049	2025-05-01 14:48:09.342027+00	3b628d15-2730-4750-9054-dca82c9dde6c
c02a281f-b04e-4122-bed3-0a9298ffd88c	5000	ce3aacd7-0ba8-488d-ac70-c8a134ea2768	2025-05-01 14:48:09.342027+00	28150363-d0b0-4636-a997-dfa79defc28e
c02a281f-b04e-4122-bed3-0a9298ffd88c	10000	98288d10-5bf0-491a-8fb0-4887cd795aa2	2025-05-01 14:48:09.342027+00	d0f9d176-b106-493a-afe2-7dfe45d8f605
c02a281f-b04e-4122-bed3-0a9298ffd88c	15000	b2854945-e588-4b22-8a45-3bd53e5cecdf	2025-05-01 14:48:09.342027+00	3b628d15-2730-4750-9054-dca82c9dde6c
8f646dcf-755d-4b73-91df-49e372628e43	5000	bc627ed8-dd3c-4540-b122-a0395436c217	2025-05-01 14:48:09.342027+00	28150363-d0b0-4636-a997-dfa79defc28e
8f646dcf-755d-4b73-91df-49e372628e43	10000	8e432c1b-38d4-4172-9fca-bcbf099d6cd5	2025-05-01 14:48:09.342027+00	d0f9d176-b106-493a-afe2-7dfe45d8f605
8f646dcf-755d-4b73-91df-49e372628e43	15000	4661f70f-f030-492a-b34d-7224725bd2df	2025-05-01 14:48:09.342027+00	3b628d15-2730-4750-9054-dca82c9dde6c
a2563c6e-a38c-4441-ab5c-5147ebcf254e	6000	e075135a-42e8-4c5d-80d7-f0e84fc35ce8	2025-05-01 15:07:25.412782+00	2a41b979-cc7b-4e77-9090-2582771c1052
a2563c6e-a38c-4441-ab5c-5147ebcf254e	8000	c8de5a37-fe80-4458-aac2-dbe4882715af	2025-05-01 15:07:25.412782+00	fb00477f-05c8-4ae2-a1fe-c779d7d2cbfb
a2563c6e-a38c-4441-ab5c-5147ebcf254e	12000	d2b719cb-b2de-44e0-a56b-25bc27e795bf	2025-05-01 15:07:25.412782+00	3d1f42e3-373b-404a-8da1-5d7aa2437f29
03d00293-9dde-4979-abe1-941f3ab67920	4000	e7fe9860-c89b-419c-9bf0-ba34537c73ab	2025-05-01 15:07:25.412782+00	2a41b979-cc7b-4e77-9090-2582771c1052
03d00293-9dde-4979-abe1-941f3ab67920	6000	f6f8f0ba-cd5c-427c-88ab-728c3e17acba	2025-05-01 15:07:25.412782+00	fb00477f-05c8-4ae2-a1fe-c779d7d2cbfb
03d00293-9dde-4979-abe1-941f3ab67920	8000	8ee1bb82-7831-4477-8abd-d77b91092491	2025-05-01 15:07:25.412782+00	3d1f42e3-373b-404a-8da1-5d7aa2437f29
e39d33ae-2e44-461f-8e02-3e03841e84b4	20000	cbd35414-d435-449c-891b-2333eead9af8	2025-05-01 15:07:25.412782+00	2a41b979-cc7b-4e77-9090-2582771c1052
e39d33ae-2e44-461f-8e02-3e03841e84b4	25000	deb94004-0269-4cfa-9616-5e499ba4b4d1	2025-05-01 15:07:25.412782+00	fb00477f-05c8-4ae2-a1fe-c779d7d2cbfb
e39d33ae-2e44-461f-8e02-3e03841e84b4	30000	6afe02bf-d7f5-488b-ace8-8cf13a6e961d	2025-05-01 15:07:25.412782+00	3d1f42e3-373b-404a-8da1-5d7aa2437f29
ca55f977-03b1-4f62-a3e1-903e864bfadb	30000	f58ffbbd-c38b-4bc0-ab5d-b04f74deb1e1	2025-05-01 15:07:25.412782+00	2a41b979-cc7b-4e77-9090-2582771c1052
ca55f977-03b1-4f62-a3e1-903e864bfadb	20000	bf8a6871-53b2-446c-a1e4-a1e2efa120aa	2025-05-01 15:07:25.412782+00	fb00477f-05c8-4ae2-a1fe-c779d7d2cbfb
ca55f977-03b1-4f62-a3e1-903e864bfadb	10000	5f3c5e6b-1939-4994-b66f-74b8866a9b7a	2025-05-01 15:07:25.412782+00	3d1f42e3-373b-404a-8da1-5d7aa2437f29
0faf7d13-5e06-42df-b8bb-a2f2f1e3da4d	5000	f3dda70b-5553-4218-a4d6-d3425e0737d1	2025-05-01 15:07:25.412782+00	2a41b979-cc7b-4e77-9090-2582771c1052
0faf7d13-5e06-42df-b8bb-a2f2f1e3da4d	10000	0515e217-7350-4892-b0e3-06619720caf6	2025-05-01 15:07:25.412782+00	fb00477f-05c8-4ae2-a1fe-c779d7d2cbfb
0faf7d13-5e06-42df-b8bb-a2f2f1e3da4d	15000	45b81355-3f99-4d02-88aa-f5f8ee58ae50	2025-05-01 15:07:25.412782+00	3d1f42e3-373b-404a-8da1-5d7aa2437f29
e1840b3e-19c9-4700-a19b-c61f236ce713	5000	18c64f46-bad0-4c48-a1da-08ff06102dbe	2025-05-01 15:07:25.412782+00	2a41b979-cc7b-4e77-9090-2582771c1052
e1840b3e-19c9-4700-a19b-c61f236ce713	10000	42290c09-7260-42bb-90e0-c9471b745843	2025-05-01 15:07:25.412782+00	fb00477f-05c8-4ae2-a1fe-c779d7d2cbfb
e1840b3e-19c9-4700-a19b-c61f236ce713	15000	b31f5b7b-e11b-4d0b-9f77-31a154cee7dd	2025-05-01 15:07:25.412782+00	3d1f42e3-373b-404a-8da1-5d7aa2437f29
329bd32c-6809-42c8-92f0-99362823b924	6000	2657011a-ad4a-4d8d-8dc7-35119d343842	2025-05-04 07:08:58.165851+00	e517f045-c842-49c7-9bd0-4abe013d9c65
329bd32c-6809-42c8-92f0-99362823b924	8000	7c49c50c-d5fe-407f-95c8-a7abb453c82f	2025-05-04 07:08:58.165851+00	09315f6e-99f4-4389-9e74-0628aa80bf91
329bd32c-6809-42c8-92f0-99362823b924	12000	70cf815e-6379-4f5a-83cd-5d2e3e9880a6	2025-05-04 07:08:58.165851+00	58151107-6253-454c-b172-8dcd31e06f8e
92396a1d-32bd-4d5a-8cfa-6483a2cc212f	4000	b52b93eb-6dc2-4eef-8f61-98b7a73b7952	2025-05-04 07:08:58.165851+00	e517f045-c842-49c7-9bd0-4abe013d9c65
92396a1d-32bd-4d5a-8cfa-6483a2cc212f	6000	56bd23a0-3385-4e77-b9df-00bef8d1c0bb	2025-05-04 07:08:58.165851+00	09315f6e-99f4-4389-9e74-0628aa80bf91
92396a1d-32bd-4d5a-8cfa-6483a2cc212f	8000	8cedf062-41be-4dc4-9b47-ecb5754ab26b	2025-05-04 07:08:58.165851+00	58151107-6253-454c-b172-8dcd31e06f8e
f0be335c-db79-43f7-94b4-4340cee103df	20000	7cf1e0f0-4580-4176-b055-d87970b629ce	2025-05-04 07:08:58.165851+00	e517f045-c842-49c7-9bd0-4abe013d9c65
f0be335c-db79-43f7-94b4-4340cee103df	25000	0744dd5d-ee1d-47be-8048-14f283dfd370	2025-05-04 07:08:58.165851+00	09315f6e-99f4-4389-9e74-0628aa80bf91
f0be335c-db79-43f7-94b4-4340cee103df	30000	aeb05f93-1eb8-4ebe-bc36-0cde34ead79c	2025-05-04 07:08:58.165851+00	58151107-6253-454c-b172-8dcd31e06f8e
833fd926-e562-408d-9e11-a2fc4dd95475	30000	e2ae0876-5efe-4517-af77-155440513443	2025-05-04 07:08:58.165851+00	e517f045-c842-49c7-9bd0-4abe013d9c65
833fd926-e562-408d-9e11-a2fc4dd95475	20000	08ee295a-f42b-475e-9566-cfda9124fc9f	2025-05-04 07:08:58.165851+00	09315f6e-99f4-4389-9e74-0628aa80bf91
833fd926-e562-408d-9e11-a2fc4dd95475	10000	cc5434c1-19a7-4bd8-a0ab-a7f07ffdc9c7	2025-05-04 07:08:58.165851+00	58151107-6253-454c-b172-8dcd31e06f8e
44bcd28a-e3ac-4687-8c55-4ffe4040a0db	5000	a2c48380-07c6-4e18-aecf-ee3a8e7481fa	2025-05-04 07:08:58.165851+00	e517f045-c842-49c7-9bd0-4abe013d9c65
44bcd28a-e3ac-4687-8c55-4ffe4040a0db	10000	f6258293-0494-4916-b540-f0b0e26a20c1	2025-05-04 07:08:58.165851+00	09315f6e-99f4-4389-9e74-0628aa80bf91
44bcd28a-e3ac-4687-8c55-4ffe4040a0db	15000	f58eabf6-6f3f-4bdd-8e12-8babc5af18c8	2025-05-04 07:08:58.165851+00	58151107-6253-454c-b172-8dcd31e06f8e
89b15111-9f60-44ac-8b4e-b9bd94c04926	5000	e119d3b5-8e59-45eb-9ffb-d1da9372efb0	2025-05-04 07:08:58.165851+00	e517f045-c842-49c7-9bd0-4abe013d9c65
89b15111-9f60-44ac-8b4e-b9bd94c04926	10000	02ccabe2-27b7-4989-9fe4-ee6ec3742ab2	2025-05-04 07:08:58.165851+00	09315f6e-99f4-4389-9e74-0628aa80bf91
89b15111-9f60-44ac-8b4e-b9bd94c04926	15000	ed59370e-4b28-41f2-b64d-a798bacf945c	2025-05-04 07:08:58.165851+00	58151107-6253-454c-b172-8dcd31e06f8e
bcdaaa49-103e-4753-8d1f-86849e636064	6000	4b3d2ade-9d26-4edb-b99b-caced92b14e6	2025-05-21 03:00:59.278422+00	22bbf7be-fb55-452e-8d47-047d4a27136a
bcdaaa49-103e-4753-8d1f-86849e636064	8000	b38529a1-6229-42d1-adb7-2773f22dd47f	2025-05-21 03:00:59.278422+00	72f7e902-ac44-4713-8222-9e805e04de6f
bcdaaa49-103e-4753-8d1f-86849e636064	12000	35094a71-ca46-4d19-be86-b5ce50231047	2025-05-21 03:00:59.278422+00	aafbad3c-bf5e-4a54-876d-c5be25856217
f4b7ea35-198d-4212-b683-a4e40a8b7910	4000	a4bdd7a0-d50d-4fdb-9f2a-0df0d2529455	2025-05-21 03:00:59.278422+00	22bbf7be-fb55-452e-8d47-047d4a27136a
f4b7ea35-198d-4212-b683-a4e40a8b7910	6000	595de864-06f6-4a74-8d0e-598c64a73769	2025-05-21 03:00:59.278422+00	72f7e902-ac44-4713-8222-9e805e04de6f
f4b7ea35-198d-4212-b683-a4e40a8b7910	8000	c512fe7e-171e-422f-9214-7e4745ef8caf	2025-05-21 03:00:59.278422+00	aafbad3c-bf5e-4a54-876d-c5be25856217
ef5025ea-4b6b-4a7d-9a29-f4d4398525d3	20000	ad8a0d17-bd42-4967-b4d6-ee80401b7ea6	2025-05-21 03:00:59.278422+00	22bbf7be-fb55-452e-8d47-047d4a27136a
ef5025ea-4b6b-4a7d-9a29-f4d4398525d3	25000	0a3bc81d-0fe9-45a1-bbc8-5e20200cd8ef	2025-05-21 03:00:59.278422+00	72f7e902-ac44-4713-8222-9e805e04de6f
ef5025ea-4b6b-4a7d-9a29-f4d4398525d3	30000	f8b97de9-b904-4786-a70e-2a05add01b09	2025-05-21 03:00:59.278422+00	aafbad3c-bf5e-4a54-876d-c5be25856217
403229fa-c9fd-407a-89f3-f8c211623943	30000	9bc452a3-b9d5-4dad-b1a5-b2fbb3c0a8e5	2025-05-21 03:00:59.278422+00	22bbf7be-fb55-452e-8d47-047d4a27136a
403229fa-c9fd-407a-89f3-f8c211623943	20000	921d7304-98c3-40e7-9622-c82570d00241	2025-05-21 03:00:59.278422+00	72f7e902-ac44-4713-8222-9e805e04de6f
403229fa-c9fd-407a-89f3-f8c211623943	10000	9ddbd6a3-3932-4b8e-b89b-c41b5d9ce528	2025-05-21 03:00:59.278422+00	aafbad3c-bf5e-4a54-876d-c5be25856217
bf50b3e3-5d1c-4cb1-af92-d27f1b7abdf8	5000	9f3fa5c4-dc0d-4b02-afd7-55315dc295e4	2025-05-21 03:00:59.278422+00	22bbf7be-fb55-452e-8d47-047d4a27136a
bf50b3e3-5d1c-4cb1-af92-d27f1b7abdf8	10000	1bff4c2d-8527-4744-905c-c16267f58efe	2025-05-21 03:00:59.278422+00	72f7e902-ac44-4713-8222-9e805e04de6f
bf50b3e3-5d1c-4cb1-af92-d27f1b7abdf8	15000	26a6abb2-f60a-464f-b271-2023717244d7	2025-05-21 03:00:59.278422+00	aafbad3c-bf5e-4a54-876d-c5be25856217
cd30dd26-a409-4a85-9dcd-34c053c31570	5000	3f736074-4feb-48c1-828e-9ca58e3669d9	2025-05-21 03:00:59.278422+00	22bbf7be-fb55-452e-8d47-047d4a27136a
cd30dd26-a409-4a85-9dcd-34c053c31570	10000	4aab157e-8a93-40b5-8ada-9bb7a011fdd3	2025-05-21 03:00:59.278422+00	72f7e902-ac44-4713-8222-9e805e04de6f
cd30dd26-a409-4a85-9dcd-34c053c31570	15000	4c2b7264-a717-4c7a-9572-0e9203ac224a	2025-05-21 03:00:59.278422+00	aafbad3c-bf5e-4a54-876d-c5be25856217
4b628038-6129-4e40-bb49-2243db2a3188	6000	207bcc06-c03c-4e54-a921-7a2864a39d7f	2025-05-25 13:38:03.846639+00	60b2f947-a1e4-4f02-93be-857b737e0aae
4b628038-6129-4e40-bb49-2243db2a3188	8000	b8495047-68c9-4937-8151-3879ce4af5f1	2025-05-25 13:38:03.846639+00	4f12960f-3ff9-4471-a4be-9558f2cdaf24
4b628038-6129-4e40-bb49-2243db2a3188	12000	607f3b48-a63d-4c81-8606-011fe6844290	2025-05-25 13:38:03.846639+00	f431deb8-0d2f-4b10-88c2-eacc6e840490
2856178c-806a-4f2d-90c8-63f05bddb27b	4000	a0de2201-ac8e-41c8-a31a-c3928f87d1f0	2025-05-25 13:38:03.846639+00	60b2f947-a1e4-4f02-93be-857b737e0aae
2856178c-806a-4f2d-90c8-63f05bddb27b	6000	96189335-f34a-4e58-b3af-fc2c29ba188a	2025-05-25 13:38:03.846639+00	4f12960f-3ff9-4471-a4be-9558f2cdaf24
2856178c-806a-4f2d-90c8-63f05bddb27b	8000	12f5c518-e58f-4b7a-93e7-4b2dad3c03ab	2025-05-25 13:38:03.846639+00	f431deb8-0d2f-4b10-88c2-eacc6e840490
0b4aa7fc-fcbc-4adc-8cec-0a8ee4adb70a	20000	2218d6b6-e53a-401a-8b02-26ba9c35ed81	2025-05-25 13:38:03.846639+00	60b2f947-a1e4-4f02-93be-857b737e0aae
0b4aa7fc-fcbc-4adc-8cec-0a8ee4adb70a	25000	bf557c4b-914a-4b35-b88e-0964f9cee556	2025-05-25 13:38:03.846639+00	4f12960f-3ff9-4471-a4be-9558f2cdaf24
0b4aa7fc-fcbc-4adc-8cec-0a8ee4adb70a	30000	c0b1febb-f0b8-444c-8d6c-c141d762bd59	2025-05-25 13:38:03.846639+00	f431deb8-0d2f-4b10-88c2-eacc6e840490
bb26cd46-d1d0-4ddc-a182-05aa3bd76d0a	6000	678c09aa-82b0-4537-9c9b-703e28d6c4c6	2025-12-24 12:15:35.563358+00	96d809da-8a60-494e-a923-0f851dc095ec
bb26cd46-d1d0-4ddc-a182-05aa3bd76d0a	8000	0aea5458-1a6b-468d-a3e7-82e7d5b18eb6	2025-12-24 12:15:35.563358+00	bca9722f-c8d2-43ad-b8bb-c34f57cff0da
bb26cd46-d1d0-4ddc-a182-05aa3bd76d0a	12000	8026988f-7bd3-47a1-b6e7-08a0b2787126	2025-12-24 12:15:35.563358+00	0a933314-040b-4b51-bd6f-ee8f0e9a2167
da09f17a-677b-4f34-a3cf-8cb1f1258ae4	5000	864c3153-714a-4059-89ad-664151717ade	2025-05-25 13:38:03.846639+00	60b2f947-a1e4-4f02-93be-857b737e0aae
da09f17a-677b-4f34-a3cf-8cb1f1258ae4	10000	c01888b9-9106-41d4-b6dc-80a59a9c1120	2025-05-25 13:38:03.846639+00	4f12960f-3ff9-4471-a4be-9558f2cdaf24
da09f17a-677b-4f34-a3cf-8cb1f1258ae4	15000	2f0fff71-0560-42f7-8c0b-3cc29197711d	2025-05-25 13:38:03.846639+00	f431deb8-0d2f-4b10-88c2-eacc6e840490
83de7f21-9ecc-47e2-8bf4-65fcb8e92434	5000	c2d96e69-55dd-41a9-9091-1b8b2f173a5f	2025-05-25 13:38:03.846639+00	60b2f947-a1e4-4f02-93be-857b737e0aae
83de7f21-9ecc-47e2-8bf4-65fcb8e92434	10000	26ab6af9-c2d3-4468-97e6-298ece6309c3	2025-05-25 13:38:03.846639+00	4f12960f-3ff9-4471-a4be-9558f2cdaf24
83de7f21-9ecc-47e2-8bf4-65fcb8e92434	15000	dfe90221-4dec-4d4f-aa8e-8de3341ca0fd	2025-05-25 13:38:03.846639+00	f431deb8-0d2f-4b10-88c2-eacc6e840490
5f27c019-0934-4727-b1f4-442e11515160	6000	7edc120c-c6d6-44f9-a35d-99b8652be129	2025-06-14 11:16:09.71107+00	6f94f581-3f5b-4f59-b374-26b0472a636b
5f27c019-0934-4727-b1f4-442e11515160	8000	1827c05c-10b7-43c5-835c-a76738b2463e	2025-06-14 11:16:09.71107+00	f27dc843-7b3f-4399-9fda-8f030acd3723
5f27c019-0934-4727-b1f4-442e11515160	12000	5b2e9bdf-8e54-4a4c-a7d5-ca39d3210d1d	2025-06-14 11:16:09.71107+00	41f44fb3-7e42-4cab-bf75-8ae3ec46a89b
eafc06e4-4c24-4cd0-9871-82a714e92a7c	4000	62dab69d-f10a-4524-820d-60486acf7be0	2025-06-14 11:16:09.71107+00	6f94f581-3f5b-4f59-b374-26b0472a636b
eafc06e4-4c24-4cd0-9871-82a714e92a7c	6000	06374711-30bc-472f-9735-a8c1c985fdfc	2025-06-14 11:16:09.71107+00	f27dc843-7b3f-4399-9fda-8f030acd3723
eafc06e4-4c24-4cd0-9871-82a714e92a7c	8000	46bf65cc-c592-4af6-86c2-11b4f44aa423	2025-06-14 11:16:09.71107+00	41f44fb3-7e42-4cab-bf75-8ae3ec46a89b
c461ad73-443e-4037-a583-6ab856f7198b	20000	c5d087ce-256f-49e2-bb41-c239c1160c01	2025-06-14 11:16:09.71107+00	6f94f581-3f5b-4f59-b374-26b0472a636b
c461ad73-443e-4037-a583-6ab856f7198b	25000	bc5488e3-b432-4352-bf7b-0cc97a48f092	2025-06-14 11:16:09.71107+00	f27dc843-7b3f-4399-9fda-8f030acd3723
c461ad73-443e-4037-a583-6ab856f7198b	30000	ce132535-4b92-4359-a380-33f131b5cb21	2025-06-14 11:16:09.71107+00	41f44fb3-7e42-4cab-bf75-8ae3ec46a89b
88fdd366-6ec2-4be9-8320-cb85984893b5	30000	70db8430-dae3-4cf3-91d2-6da2ca769245	2025-06-14 11:16:09.71107+00	6f94f581-3f5b-4f59-b374-26b0472a636b
88fdd366-6ec2-4be9-8320-cb85984893b5	20000	c2112f40-c72d-4f3e-ae0b-31ba27cb3f8d	2025-06-14 11:16:09.71107+00	f27dc843-7b3f-4399-9fda-8f030acd3723
88fdd366-6ec2-4be9-8320-cb85984893b5	10000	671fefa0-bbae-4c37-b99d-e43bc279e182	2025-06-14 11:16:09.71107+00	41f44fb3-7e42-4cab-bf75-8ae3ec46a89b
4d012e22-2ba5-4fb3-a676-bddc9c868032	5000	e104c49d-0ba3-4990-8bfc-256d5b9c5fa9	2025-06-14 11:16:09.71107+00	6f94f581-3f5b-4f59-b374-26b0472a636b
4d012e22-2ba5-4fb3-a676-bddc9c868032	10000	ca447d6b-ddea-4a01-a9d6-f3d0a39c5b37	2025-06-14 11:16:09.71107+00	f27dc843-7b3f-4399-9fda-8f030acd3723
4d012e22-2ba5-4fb3-a676-bddc9c868032	15000	cf2899a0-31f4-4a76-ade7-77d657901c7f	2025-06-14 11:16:09.71107+00	41f44fb3-7e42-4cab-bf75-8ae3ec46a89b
0428cdcd-bbcc-4461-be92-f01ccd06fb0a	5000	fde90229-6eb8-4dea-90bb-e58af3e77d0b	2025-06-14 11:16:09.71107+00	6f94f581-3f5b-4f59-b374-26b0472a636b
0428cdcd-bbcc-4461-be92-f01ccd06fb0a	10000	c0df4a97-13a5-4833-a678-7514202e40d3	2025-06-14 11:16:09.71107+00	f27dc843-7b3f-4399-9fda-8f030acd3723
0428cdcd-bbcc-4461-be92-f01ccd06fb0a	15000	0bebb518-e774-48a5-9e51-4c4a2a33a6f8	2025-06-14 11:16:09.71107+00	41f44fb3-7e42-4cab-bf75-8ae3ec46a89b
34f82a36-168a-404c-a99e-78db5b8a1aff	6000	7a790cd4-9ad9-4f67-91d4-d76e42fdf7ed	2025-06-14 11:30:20.804019+00	0d32680c-8e07-445b-b6d1-daa522ef21f2
34f82a36-168a-404c-a99e-78db5b8a1aff	8000	599d7d42-195d-4a2b-baa2-2e52feb1e2cd	2025-06-14 11:30:20.804019+00	884c9b2e-7969-4ed1-b07c-be130c75e8c3
34f82a36-168a-404c-a99e-78db5b8a1aff	12000	c275c0ac-1a97-45b0-9aab-ee283bc6f62d	2025-06-14 11:30:20.804019+00	0abbf487-b975-410a-a8cc-00297a719c31
01b44e66-bf43-4fb8-99ae-d65ea0c27e0b	4000	69d47ad0-ea29-4695-bcb7-990a786aeb44	2025-06-14 11:30:20.804019+00	0d32680c-8e07-445b-b6d1-daa522ef21f2
01b44e66-bf43-4fb8-99ae-d65ea0c27e0b	6000	828ec87f-3979-4aec-a07a-6f6d44ab7a89	2025-06-14 11:30:20.804019+00	884c9b2e-7969-4ed1-b07c-be130c75e8c3
01b44e66-bf43-4fb8-99ae-d65ea0c27e0b	8000	f03a8274-d107-46a9-8acc-00f5e46561ec	2025-06-14 11:30:20.804019+00	0abbf487-b975-410a-a8cc-00297a719c31
64a9efa0-8fd7-4962-862a-af801daf6362	20000	2fba9576-16fa-4335-8f3f-e355553fb5c4	2025-06-14 11:30:20.804019+00	0d32680c-8e07-445b-b6d1-daa522ef21f2
64a9efa0-8fd7-4962-862a-af801daf6362	25000	7d0f1e3e-ff51-4937-9c3f-508d2f9fc53f	2025-06-14 11:30:20.804019+00	884c9b2e-7969-4ed1-b07c-be130c75e8c3
64a9efa0-8fd7-4962-862a-af801daf6362	30000	a3dbf1f4-018c-4d60-a647-b4b680d6e92d	2025-06-14 11:30:20.804019+00	0abbf487-b975-410a-a8cc-00297a719c31
273b2f24-10a8-49ef-b08a-325d6d81a369	30000	4196b6b7-b845-459d-b179-96a2ea6005b4	2025-06-14 11:30:20.804019+00	0d32680c-8e07-445b-b6d1-daa522ef21f2
273b2f24-10a8-49ef-b08a-325d6d81a369	20000	3675cd33-9cbf-4875-839a-5fc6fb970e58	2025-06-14 11:30:20.804019+00	884c9b2e-7969-4ed1-b07c-be130c75e8c3
273b2f24-10a8-49ef-b08a-325d6d81a369	10000	954030ff-1b26-48f6-819b-c14bde128461	2025-06-14 11:30:20.804019+00	0abbf487-b975-410a-a8cc-00297a719c31
6abbf49c-2414-45ee-b58a-42d5b500e323	5000	cd157df8-cb08-4ae9-8fd0-21c89ea3ce1a	2025-06-14 11:30:20.804019+00	0d32680c-8e07-445b-b6d1-daa522ef21f2
6abbf49c-2414-45ee-b58a-42d5b500e323	10000	99a74f85-841f-42ad-aa1b-a75b1270ad32	2025-06-14 11:30:20.804019+00	884c9b2e-7969-4ed1-b07c-be130c75e8c3
6abbf49c-2414-45ee-b58a-42d5b500e323	15000	cdb65977-f3f0-4395-b706-6cf4100e0b27	2025-06-14 11:30:20.804019+00	0abbf487-b975-410a-a8cc-00297a719c31
d34239c1-a465-4711-ac87-3b35893efba4	5000	6d170a3e-55e0-48cc-99d0-d170c5a0eaa2	2025-06-14 11:30:20.804019+00	0d32680c-8e07-445b-b6d1-daa522ef21f2
d34239c1-a465-4711-ac87-3b35893efba4	10000	9deeb96d-9afc-4cc7-8bde-fca4e294c8f5	2025-06-14 11:30:20.804019+00	884c9b2e-7969-4ed1-b07c-be130c75e8c3
d34239c1-a465-4711-ac87-3b35893efba4	15000	24dedd25-97ef-4d4b-bd81-c130ef6b398a	2025-06-14 11:30:20.804019+00	0abbf487-b975-410a-a8cc-00297a719c31
d52135f4-a1c8-4256-bf3a-a07efde5579d	6000	ff719f32-0686-4a8a-b2fc-d5dbd8ff7a0a	2025-06-14 11:46:02.198027+00	08e9d990-a63d-41c7-9fcc-327cbe5f9254
d52135f4-a1c8-4256-bf3a-a07efde5579d	8000	6249b6e0-a6cf-437f-bde3-c5cc3a14e0d7	2025-06-14 11:46:02.198027+00	f3d5a4ea-1eae-42bf-8b5e-722f14c13042
d52135f4-a1c8-4256-bf3a-a07efde5579d	12000	e078192a-1755-44ba-b0ee-b4a2add1110a	2025-06-14 11:46:02.198027+00	07394679-0e00-4615-b54c-7f256f0819b0
93e4cda0-1194-4ce5-8374-73a1ed103294	4000	a67cfe74-baa1-4ea3-8fa8-e96917945586	2025-06-14 11:46:02.198027+00	08e9d990-a63d-41c7-9fcc-327cbe5f9254
93e4cda0-1194-4ce5-8374-73a1ed103294	6000	994dbe23-8e5e-40e8-8284-68285800d4e5	2025-06-14 11:46:02.198027+00	f3d5a4ea-1eae-42bf-8b5e-722f14c13042
93e4cda0-1194-4ce5-8374-73a1ed103294	8000	3196eb09-7120-43cf-b962-e28d11bc4e2f	2025-06-14 11:46:02.198027+00	07394679-0e00-4615-b54c-7f256f0819b0
9dfd99d7-f13f-44ac-abef-49ae502e5183	20000	98d47b7e-7064-4531-aa6c-a77655aa88cc	2025-06-14 11:46:02.198027+00	08e9d990-a63d-41c7-9fcc-327cbe5f9254
9dfd99d7-f13f-44ac-abef-49ae502e5183	25000	903a3cb0-32ea-4271-aed8-1f0fda36d522	2025-06-14 11:46:02.198027+00	f3d5a4ea-1eae-42bf-8b5e-722f14c13042
9dfd99d7-f13f-44ac-abef-49ae502e5183	30000	8dd8eefc-dca5-46c4-944b-6724f722d165	2025-06-14 11:46:02.198027+00	07394679-0e00-4615-b54c-7f256f0819b0
d4db4be0-a56b-4ab2-9768-dbde438f53d3	30000	7574e0a0-c61e-4268-91ab-0840d69fe972	2025-06-14 11:46:02.198027+00	08e9d990-a63d-41c7-9fcc-327cbe5f9254
d4db4be0-a56b-4ab2-9768-dbde438f53d3	20000	8ecf2fab-487e-4e9f-a913-c4e4d70c20fb	2025-06-14 11:46:02.198027+00	f3d5a4ea-1eae-42bf-8b5e-722f14c13042
d4db4be0-a56b-4ab2-9768-dbde438f53d3	10000	647ddaba-2bee-4673-a725-760d17039f8d	2025-06-14 11:46:02.198027+00	07394679-0e00-4615-b54c-7f256f0819b0
39a2098e-3769-4e07-99a4-0a2795e21f25	5000	2a52ed22-8455-41ea-919f-40b4d1ec5314	2025-06-14 11:46:02.198027+00	08e9d990-a63d-41c7-9fcc-327cbe5f9254
39a2098e-3769-4e07-99a4-0a2795e21f25	10000	ecf3aaed-eda8-4b01-81e2-30cbfe69ab2e	2025-06-14 11:46:02.198027+00	f3d5a4ea-1eae-42bf-8b5e-722f14c13042
39a2098e-3769-4e07-99a4-0a2795e21f25	15000	3923f784-a19a-4ef4-8d23-3ae9b6334bb0	2025-06-14 11:46:02.198027+00	07394679-0e00-4615-b54c-7f256f0819b0
8c04f403-4cca-449c-86ab-a3ce267422e5	5000	3447a4aa-ac8f-4937-9b0b-5f531665c196	2025-06-14 11:46:02.198027+00	08e9d990-a63d-41c7-9fcc-327cbe5f9254
8c04f403-4cca-449c-86ab-a3ce267422e5	10000	5d05bbe1-bb66-4720-b32f-92bb6de7efb8	2025-06-14 11:46:02.198027+00	f3d5a4ea-1eae-42bf-8b5e-722f14c13042
8c04f403-4cca-449c-86ab-a3ce267422e5	15000	0f084d98-9dbf-489e-9214-db4b17cb57fa	2025-06-14 11:46:02.198027+00	07394679-0e00-4615-b54c-7f256f0819b0
610b97f4-bd13-489c-920f-ebf903ade076	6000	1f0988f9-45c4-4e25-bfb6-5f4ecd6ced09	2025-06-14 11:48:28.089577+00	1939d1a5-28aa-4e56-9ee7-1c75fe8fce7d
610b97f4-bd13-489c-920f-ebf903ade076	8000	345d6914-33a7-4de2-87fe-98b4e8a6e264	2025-06-14 11:48:28.089577+00	4a3525e4-0dc5-4baf-a74f-c756eab654ee
610b97f4-bd13-489c-920f-ebf903ade076	12000	bd4e5cb2-8a6c-41d5-8eb5-b1a9773e1b51	2025-06-14 11:48:28.089577+00	ca84efee-efb3-4890-8bd9-66a0a6aacd6d
15959fcf-6fb0-4719-a09b-2ce47562700b	4000	716c87d5-bb33-4de7-8197-c5a19f482cb7	2025-06-14 11:48:28.089577+00	1939d1a5-28aa-4e56-9ee7-1c75fe8fce7d
15959fcf-6fb0-4719-a09b-2ce47562700b	6000	33c81c81-0a34-443d-b05b-3650bdda4c66	2025-06-14 11:48:28.089577+00	4a3525e4-0dc5-4baf-a74f-c756eab654ee
15959fcf-6fb0-4719-a09b-2ce47562700b	8000	9c053175-9d78-46f5-b40e-019e7293a382	2025-06-14 11:48:28.089577+00	ca84efee-efb3-4890-8bd9-66a0a6aacd6d
5623a90d-ac3d-4c42-b60c-b006cf5b640c	20000	dca7ee9c-c501-4940-aa6e-7e03113d012e	2025-06-14 11:48:28.089577+00	1939d1a5-28aa-4e56-9ee7-1c75fe8fce7d
5623a90d-ac3d-4c42-b60c-b006cf5b640c	25000	536331b5-015e-4c44-8571-84ba826d7629	2025-06-14 11:48:28.089577+00	4a3525e4-0dc5-4baf-a74f-c756eab654ee
5623a90d-ac3d-4c42-b60c-b006cf5b640c	30000	4518b281-b3bd-41b8-a92d-cb2367fcf26e	2025-06-14 11:48:28.089577+00	ca84efee-efb3-4890-8bd9-66a0a6aacd6d
454d673e-c28c-4400-9ec3-89ef0592181c	30000	f0a65bd5-8af6-4b3f-8d2a-cb2c14a05986	2025-06-14 11:48:28.089577+00	1939d1a5-28aa-4e56-9ee7-1c75fe8fce7d
454d673e-c28c-4400-9ec3-89ef0592181c	20000	f43c6e1c-6912-475c-87de-c72b120d6222	2025-06-14 11:48:28.089577+00	4a3525e4-0dc5-4baf-a74f-c756eab654ee
454d673e-c28c-4400-9ec3-89ef0592181c	10000	04d4b086-f039-42f2-94f7-6b65d6396e9a	2025-06-14 11:48:28.089577+00	ca84efee-efb3-4890-8bd9-66a0a6aacd6d
f72db239-2733-4493-9f83-eaed2e6125bb	5000	4e9a8792-936d-4938-9b76-529419c4c5cd	2025-06-14 11:48:28.089577+00	1939d1a5-28aa-4e56-9ee7-1c75fe8fce7d
f72db239-2733-4493-9f83-eaed2e6125bb	10000	d9380836-28d7-41ca-a8a1-162e7bef85b1	2025-06-14 11:48:28.089577+00	4a3525e4-0dc5-4baf-a74f-c756eab654ee
f72db239-2733-4493-9f83-eaed2e6125bb	15000	8f11e887-c292-4ded-b526-a4b48808d301	2025-06-14 11:48:28.089577+00	ca84efee-efb3-4890-8bd9-66a0a6aacd6d
b55cef53-1215-4473-b783-bdaf706a5442	5000	056a55db-cae4-4e9b-b195-0a6ecf3cd83b	2025-06-14 11:48:28.089577+00	1939d1a5-28aa-4e56-9ee7-1c75fe8fce7d
b55cef53-1215-4473-b783-bdaf706a5442	10000	8a2e4f81-1bfc-40bd-81fa-50905578c491	2025-06-14 11:48:28.089577+00	4a3525e4-0dc5-4baf-a74f-c756eab654ee
b55cef53-1215-4473-b783-bdaf706a5442	15000	960910ba-e189-4975-a2a5-cac895842763	2025-06-14 11:48:28.089577+00	ca84efee-efb3-4890-8bd9-66a0a6aacd6d
f8295cf3-8a3c-40f1-8598-8ee31c8091b3	6000	7b931f86-4a98-4148-a744-316e06c0a69b	2025-06-14 11:49:25.638803+00	ff0013fb-fa28-4e5b-a56a-3dd13c232ae0
f8295cf3-8a3c-40f1-8598-8ee31c8091b3	8000	0359fb43-e80c-4dca-869f-d06a036e2cd8	2025-06-14 11:49:25.638803+00	95451032-e8b9-42e6-b2a0-a8b996cf57eb
f8295cf3-8a3c-40f1-8598-8ee31c8091b3	12000	af37ee79-30aa-43d3-a7d3-c0c66d521912	2025-06-14 11:49:25.638803+00	b9d4123f-5e0a-430e-a18d-8d9abc8068c6
ac85c022-b3c9-4359-a1e0-15b2b4e09755	4000	715f63d4-8d5b-4509-9fe5-7e21c290ff87	2025-06-14 11:49:25.638803+00	ff0013fb-fa28-4e5b-a56a-3dd13c232ae0
ac85c022-b3c9-4359-a1e0-15b2b4e09755	6000	4631b548-ba48-4107-b4b3-da147053abe7	2025-06-14 11:49:25.638803+00	95451032-e8b9-42e6-b2a0-a8b996cf57eb
ac85c022-b3c9-4359-a1e0-15b2b4e09755	8000	89f2f4b0-2d83-4ea6-9ff9-98e6684a3c6f	2025-06-14 11:49:25.638803+00	b9d4123f-5e0a-430e-a18d-8d9abc8068c6
1405a614-4307-4ea9-bdc3-a648c1b02392	20000	bac0d234-211b-4e97-b3b7-38ae5a08fdf4	2025-06-14 11:49:25.638803+00	ff0013fb-fa28-4e5b-a56a-3dd13c232ae0
1405a614-4307-4ea9-bdc3-a648c1b02392	25000	35242e14-3dbd-4c2e-8d7e-d7ffc750c2b3	2025-06-14 11:49:25.638803+00	95451032-e8b9-42e6-b2a0-a8b996cf57eb
1405a614-4307-4ea9-bdc3-a648c1b02392	30000	6ad8ccd8-5807-4906-9138-2447312f416f	2025-06-14 11:49:25.638803+00	b9d4123f-5e0a-430e-a18d-8d9abc8068c6
6de5d5a7-d097-495f-8335-66df0e6f1096	30000	989f7a09-6819-4f58-bb77-c2b89f6f09a0	2025-06-14 11:49:25.638803+00	ff0013fb-fa28-4e5b-a56a-3dd13c232ae0
6de5d5a7-d097-495f-8335-66df0e6f1096	20000	68857f9f-cc9e-46ae-9c83-cb4945957af0	2025-06-14 11:49:25.638803+00	95451032-e8b9-42e6-b2a0-a8b996cf57eb
6de5d5a7-d097-495f-8335-66df0e6f1096	10000	668dcb3c-d5f0-4e83-aadc-fa576e9d298d	2025-06-14 11:49:25.638803+00	b9d4123f-5e0a-430e-a18d-8d9abc8068c6
3beff625-0bfb-4000-9d02-1c9f0482aa3b	5000	853f2bc8-4593-4006-9874-1050ee10f63a	2025-06-14 11:49:25.638803+00	ff0013fb-fa28-4e5b-a56a-3dd13c232ae0
3beff625-0bfb-4000-9d02-1c9f0482aa3b	10000	1f8e9dab-e681-4c6a-ba6b-1fe7382e1a9f	2025-06-14 11:49:25.638803+00	95451032-e8b9-42e6-b2a0-a8b996cf57eb
3beff625-0bfb-4000-9d02-1c9f0482aa3b	15000	06cbc1d4-422b-4ad9-a0f9-99ba795fd4c6	2025-06-14 11:49:25.638803+00	b9d4123f-5e0a-430e-a18d-8d9abc8068c6
f965c478-fb9d-4c42-8815-8150776af29a	5000	76b357a9-fce4-4f07-aec2-1c5a9e688715	2025-06-14 11:49:25.638803+00	ff0013fb-fa28-4e5b-a56a-3dd13c232ae0
f965c478-fb9d-4c42-8815-8150776af29a	10000	6239fed3-ed1a-4796-8e75-6fcc05832826	2025-06-14 11:49:25.638803+00	95451032-e8b9-42e6-b2a0-a8b996cf57eb
f965c478-fb9d-4c42-8815-8150776af29a	15000	4007fbad-0f73-4ccb-85e2-12f32eb719ef	2025-06-14 11:49:25.638803+00	b9d4123f-5e0a-430e-a18d-8d9abc8068c6
e3617730-b93a-4414-a419-f0083705190f	6000	62d3fffb-246d-4f9b-ad30-4940cfd91d76	2025-06-15 03:16:52.249521+00	14916f75-0143-4bee-b423-6c90274fc4fe
e3617730-b93a-4414-a419-f0083705190f	8000	cc59a129-a7fb-4c04-a3c2-d1edd70d0313	2025-06-15 03:16:52.249521+00	e4ec5b31-a011-44ae-8131-d71fef68b6b2
e3617730-b93a-4414-a419-f0083705190f	12000	4f3595c8-bf14-4b7f-aaf8-150dcfd35d8f	2025-06-15 03:16:52.249521+00	dc0ed58d-3580-4ee8-ba3e-5f38d2d0a19a
c6dfda8e-b3a5-4103-af9f-deb7db5bb403	4000	0f1944ec-4736-4757-ac80-88957fb961e3	2025-06-15 03:16:52.249521+00	14916f75-0143-4bee-b423-6c90274fc4fe
c6dfda8e-b3a5-4103-af9f-deb7db5bb403	6000	ab47ea15-3536-4e87-bf00-31c202dfd0af	2025-06-15 03:16:52.249521+00	e4ec5b31-a011-44ae-8131-d71fef68b6b2
c6dfda8e-b3a5-4103-af9f-deb7db5bb403	8000	cf53a8d2-def7-4748-b474-aa26e98324a8	2025-06-15 03:16:52.249521+00	dc0ed58d-3580-4ee8-ba3e-5f38d2d0a19a
817157c3-c41d-4578-ab1d-361cd49d4bd7	20000	49230512-c73a-4f4d-8cec-08c8d3b2d654	2025-06-15 03:16:52.249521+00	14916f75-0143-4bee-b423-6c90274fc4fe
817157c3-c41d-4578-ab1d-361cd49d4bd7	25000	1f030596-8963-4768-853e-2ac549b8c896	2025-06-15 03:16:52.249521+00	e4ec5b31-a011-44ae-8131-d71fef68b6b2
817157c3-c41d-4578-ab1d-361cd49d4bd7	30000	31b15cd3-552d-4088-9ca1-11a4f0e9831a	2025-06-15 03:16:52.249521+00	dc0ed58d-3580-4ee8-ba3e-5f38d2d0a19a
ce9d43df-4384-42f8-af2f-68dd8af4ebc9	30000	0dd9cd88-885a-41d8-a702-2497218599a6	2025-06-15 03:16:52.249521+00	14916f75-0143-4bee-b423-6c90274fc4fe
ce9d43df-4384-42f8-af2f-68dd8af4ebc9	20000	8059cd96-08d2-4c37-91c9-fe415ed8dcaa	2025-06-15 03:16:52.249521+00	e4ec5b31-a011-44ae-8131-d71fef68b6b2
ce9d43df-4384-42f8-af2f-68dd8af4ebc9	10000	d441f6f7-7198-4ee6-93f9-72baeaf61e53	2025-06-15 03:16:52.249521+00	dc0ed58d-3580-4ee8-ba3e-5f38d2d0a19a
ca178f38-09c5-4835-afe5-b44483bfcaa5	5000	d94da8df-fe1e-4b68-b341-eb4822879372	2025-06-15 03:16:52.249521+00	14916f75-0143-4bee-b423-6c90274fc4fe
ca178f38-09c5-4835-afe5-b44483bfcaa5	10000	0abd9d57-5cf4-471b-92a2-c31d1ba57554	2025-06-15 03:16:52.249521+00	e4ec5b31-a011-44ae-8131-d71fef68b6b2
ca178f38-09c5-4835-afe5-b44483bfcaa5	15000	ed09ab99-1663-413c-9991-40e36c713cd7	2025-06-15 03:16:52.249521+00	dc0ed58d-3580-4ee8-ba3e-5f38d2d0a19a
e63fbbbf-dcd3-463e-8e59-fd71af5d2a7d	5000	b50d9ecf-11ff-4c3f-8ef8-20f26f8b33fa	2025-06-15 03:16:52.249521+00	14916f75-0143-4bee-b423-6c90274fc4fe
e63fbbbf-dcd3-463e-8e59-fd71af5d2a7d	10000	ea4fa19d-2cb5-4b3d-8c54-9c39d893f90d	2025-06-15 03:16:52.249521+00	e4ec5b31-a011-44ae-8131-d71fef68b6b2
e63fbbbf-dcd3-463e-8e59-fd71af5d2a7d	15000	558e2d95-8120-4c3a-97f1-c7c7ca42b022	2025-06-15 03:16:52.249521+00	dc0ed58d-3580-4ee8-ba3e-5f38d2d0a19a
f22d1eec-f9c3-4bfc-8794-f4a143851d98	6000	a952730e-1bcb-414b-82d2-5791654010c4	2025-06-15 03:18:59.694843+00	d7c97574-2033-44fe-aeea-27c42d4c3cd1
f22d1eec-f9c3-4bfc-8794-f4a143851d98	8000	ab777408-fe54-4c03-983c-05e70b5010c7	2025-06-15 03:18:59.694843+00	17f7c8db-f32d-4b27-b591-f390d4e6de5d
f22d1eec-f9c3-4bfc-8794-f4a143851d98	12000	732b41b6-6c08-413e-924f-8786ff6a7059	2025-06-15 03:18:59.694843+00	151315ce-f550-40f4-9ead-d73e8d379f73
57afe291-332a-4b3c-8d64-1f2536d531bc	4000	4cba4988-5258-4397-90a3-6ea828af7e9b	2025-06-15 03:18:59.694843+00	d7c97574-2033-44fe-aeea-27c42d4c3cd1
57afe291-332a-4b3c-8d64-1f2536d531bc	6000	7d8749eb-8946-45da-8854-59ec6465d070	2025-06-15 03:18:59.694843+00	17f7c8db-f32d-4b27-b591-f390d4e6de5d
57afe291-332a-4b3c-8d64-1f2536d531bc	8000	d4202b0b-7d7b-4f1e-98ec-286d178fa7c4	2025-06-15 03:18:59.694843+00	151315ce-f550-40f4-9ead-d73e8d379f73
d0db260f-1157-42b9-98e3-5096da6354ad	20000	07dc8800-7eb9-4351-ad18-83d12ce8a9aa	2025-06-15 03:18:59.694843+00	d7c97574-2033-44fe-aeea-27c42d4c3cd1
d0db260f-1157-42b9-98e3-5096da6354ad	25000	0eaeeab8-7323-488a-a371-9c1e36e1ac01	2025-06-15 03:18:59.694843+00	17f7c8db-f32d-4b27-b591-f390d4e6de5d
d0db260f-1157-42b9-98e3-5096da6354ad	30000	d3a78f63-a048-457f-8bc9-bb45f2ca3486	2025-06-15 03:18:59.694843+00	151315ce-f550-40f4-9ead-d73e8d379f73
068a3789-571a-40d4-b9a2-7529e8f87ee9	30000	e6b7c09f-92dd-4dbe-ac5c-cb5b69350595	2025-06-15 03:18:59.694843+00	d7c97574-2033-44fe-aeea-27c42d4c3cd1
068a3789-571a-40d4-b9a2-7529e8f87ee9	20000	f9d813cb-a875-44f8-af3a-98fd929346da	2025-06-15 03:18:59.694843+00	17f7c8db-f32d-4b27-b591-f390d4e6de5d
068a3789-571a-40d4-b9a2-7529e8f87ee9	10000	f7402ad8-5e48-43a6-af1c-d84b47ef97b9	2025-06-15 03:18:59.694843+00	151315ce-f550-40f4-9ead-d73e8d379f73
e6bd7ac4-dace-4b32-bf67-e373f705c8c1	5000	1ab757e0-c338-4b7c-a511-ec16d3231ddf	2025-06-15 03:18:59.694843+00	d7c97574-2033-44fe-aeea-27c42d4c3cd1
e6bd7ac4-dace-4b32-bf67-e373f705c8c1	10000	b29a2da9-cdd2-4dbd-9a4a-cd1bddb4f4ea	2025-06-15 03:18:59.694843+00	17f7c8db-f32d-4b27-b591-f390d4e6de5d
e6bd7ac4-dace-4b32-bf67-e373f705c8c1	15000	dbccea82-a4ed-4d31-ae04-53578ea0e6db	2025-06-15 03:18:59.694843+00	151315ce-f550-40f4-9ead-d73e8d379f73
a3190994-586f-41e7-9f9b-dfcf3db3b057	5000	671d5f11-94ec-4073-b09e-0c9853852d5e	2025-06-15 03:18:59.694843+00	d7c97574-2033-44fe-aeea-27c42d4c3cd1
a3190994-586f-41e7-9f9b-dfcf3db3b057	10000	0f527dab-4820-44c3-9512-484f89cf686d	2025-06-15 03:18:59.694843+00	17f7c8db-f32d-4b27-b591-f390d4e6de5d
a3190994-586f-41e7-9f9b-dfcf3db3b057	15000	74b86e2f-5b37-4132-8cc1-0a7cdad9f637	2025-06-15 03:18:59.694843+00	151315ce-f550-40f4-9ead-d73e8d379f73
2bd4b9ce-c924-4d4f-803d-7d553314d5ac	6000	887325d5-629d-415d-850c-9989444a1943	2025-06-15 03:20:21.276696+00	ca9366e2-0d85-420c-a757-40e22dedb68c
2bd4b9ce-c924-4d4f-803d-7d553314d5ac	8000	c7a71da2-f5c4-47be-9ec8-d6682d346929	2025-06-15 03:20:21.276696+00	13600809-d7f4-437e-976e-0ba6a3c1105b
2bd4b9ce-c924-4d4f-803d-7d553314d5ac	12000	60358718-bdf0-4b90-a65f-02a6e65de8c7	2025-06-15 03:20:21.276696+00	6c9fcc44-729c-4d13-b24c-0078a02c426c
8197274e-a101-49c8-8847-7bf8d7f1b1d5	4000	7cc9b4dd-c1b7-4883-be9e-41810197b8a3	2025-06-15 03:20:21.276696+00	ca9366e2-0d85-420c-a757-40e22dedb68c
8197274e-a101-49c8-8847-7bf8d7f1b1d5	6000	bef502e3-0302-4d15-a5b5-2109854ce75d	2025-06-15 03:20:21.276696+00	13600809-d7f4-437e-976e-0ba6a3c1105b
8197274e-a101-49c8-8847-7bf8d7f1b1d5	8000	b0ec016e-2575-4cf6-8f23-6272d334a78e	2025-06-15 03:20:21.276696+00	6c9fcc44-729c-4d13-b24c-0078a02c426c
bab86748-1d04-42a1-ba65-4935d566a646	20000	510fb36d-6193-4696-bedb-ec5954473b6d	2025-06-15 03:20:21.276696+00	ca9366e2-0d85-420c-a757-40e22dedb68c
bab86748-1d04-42a1-ba65-4935d566a646	25000	4f332b25-1ca1-4997-bc94-a85bb2be7e21	2025-06-15 03:20:21.276696+00	13600809-d7f4-437e-976e-0ba6a3c1105b
bab86748-1d04-42a1-ba65-4935d566a646	30000	750d636d-1dcf-4872-a6ae-cf031168ac37	2025-06-15 03:20:21.276696+00	6c9fcc44-729c-4d13-b24c-0078a02c426c
c7f97945-8c5b-4923-ac30-40c7fea95dd5	30000	3fdf3b39-780c-452f-a6d5-531b742e54ea	2025-06-15 03:20:21.276696+00	ca9366e2-0d85-420c-a757-40e22dedb68c
c7f97945-8c5b-4923-ac30-40c7fea95dd5	20000	9e343764-0269-4550-908d-a4992b655b09	2025-06-15 03:20:21.276696+00	13600809-d7f4-437e-976e-0ba6a3c1105b
c7f97945-8c5b-4923-ac30-40c7fea95dd5	10000	20344cc5-71db-41cd-b72a-fd14e69c2b93	2025-06-15 03:20:21.276696+00	6c9fcc44-729c-4d13-b24c-0078a02c426c
59f963b9-c948-4481-ab66-82ade2ffd74f	5000	782c70c0-b999-4235-83ed-6232df495e2e	2025-06-15 03:20:21.276696+00	ca9366e2-0d85-420c-a757-40e22dedb68c
59f963b9-c948-4481-ab66-82ade2ffd74f	10000	59e27cc2-a4ff-4edf-afcf-e196a1efbd39	2025-06-15 03:20:21.276696+00	13600809-d7f4-437e-976e-0ba6a3c1105b
59f963b9-c948-4481-ab66-82ade2ffd74f	15000	d0d54b27-f34d-416f-a5eb-7961cbe314f4	2025-06-15 03:20:21.276696+00	6c9fcc44-729c-4d13-b24c-0078a02c426c
90b398f6-018b-41ec-a302-0263040c9145	5000	d7c41feb-9e94-4b2b-a3a8-e3fe3cf87a18	2025-06-15 03:20:21.276696+00	ca9366e2-0d85-420c-a757-40e22dedb68c
90b398f6-018b-41ec-a302-0263040c9145	10000	60c46d06-73f6-4f26-9e3a-54a10b3196a3	2025-06-15 03:20:21.276696+00	13600809-d7f4-437e-976e-0ba6a3c1105b
90b398f6-018b-41ec-a302-0263040c9145	15000	36c17672-c93f-41f0-aea5-51b6ed4bff2e	2025-06-15 03:20:21.276696+00	6c9fcc44-729c-4d13-b24c-0078a02c426c
4cfd2184-82a5-4894-acdd-902339a90e9b	6000	2a5a4250-c78d-41d0-b675-0f25b2adb782	2025-06-15 03:26:37.883854+00	d157f3d2-15a9-4980-a415-54e60a1eab3c
4cfd2184-82a5-4894-acdd-902339a90e9b	8000	3759bb16-df8b-4b60-b2f9-198ee6910f9c	2025-06-15 03:26:37.883854+00	e5438a93-f9cf-4d79-a20e-eda85f191a6b
4cfd2184-82a5-4894-acdd-902339a90e9b	12000	7284e84f-953e-4faa-94cc-c100712f06be	2025-06-15 03:26:37.883854+00	4e42b7ac-5287-429c-983a-fb1defd8aa6d
50cb9da6-4418-4faf-918c-5807b3b44317	4000	681abb56-8067-4251-8af4-388022f3d1aa	2025-06-15 03:26:37.883854+00	d157f3d2-15a9-4980-a415-54e60a1eab3c
50cb9da6-4418-4faf-918c-5807b3b44317	6000	316cc646-fbf1-4fa9-8898-97de16dc5301	2025-06-15 03:26:37.883854+00	e5438a93-f9cf-4d79-a20e-eda85f191a6b
50cb9da6-4418-4faf-918c-5807b3b44317	8000	b4edcd0a-121b-471b-8e53-a03c8a044e86	2025-06-15 03:26:37.883854+00	4e42b7ac-5287-429c-983a-fb1defd8aa6d
c59644f9-83cb-4cbe-8dde-7a370a29b16b	20000	6d0c0622-a746-47c5-aa94-01e9d7c79687	2025-06-15 03:26:37.883854+00	d157f3d2-15a9-4980-a415-54e60a1eab3c
c59644f9-83cb-4cbe-8dde-7a370a29b16b	25000	746243b2-c7ba-41c9-8862-29b194c3a0c7	2025-06-15 03:26:37.883854+00	e5438a93-f9cf-4d79-a20e-eda85f191a6b
c59644f9-83cb-4cbe-8dde-7a370a29b16b	30000	d59d636c-cc9d-45a0-84b4-664e22ef30e7	2025-06-15 03:26:37.883854+00	4e42b7ac-5287-429c-983a-fb1defd8aa6d
b0a1e8e2-42b0-416e-bcb6-9b5d09fff25e	30000	f8a5faa1-7ead-4502-a38f-7abc7d07a82e	2025-06-15 03:26:37.883854+00	d157f3d2-15a9-4980-a415-54e60a1eab3c
b0a1e8e2-42b0-416e-bcb6-9b5d09fff25e	20000	00b7580c-8fb9-47ac-91bf-366a93fe52b7	2025-06-15 03:26:37.883854+00	e5438a93-f9cf-4d79-a20e-eda85f191a6b
b0a1e8e2-42b0-416e-bcb6-9b5d09fff25e	10000	9a9e7680-67a2-472f-846c-4d34aae58a3e	2025-06-15 03:26:37.883854+00	4e42b7ac-5287-429c-983a-fb1defd8aa6d
fb5087f3-5683-4000-81d6-9f433ac5f62a	5000	346871fb-91c4-43b8-a4ab-34a4627d26fb	2025-06-15 03:26:37.883854+00	d157f3d2-15a9-4980-a415-54e60a1eab3c
fb5087f3-5683-4000-81d6-9f433ac5f62a	10000	5f212644-4fcd-412c-a726-a33b5505e112	2025-06-15 03:26:37.883854+00	e5438a93-f9cf-4d79-a20e-eda85f191a6b
fb5087f3-5683-4000-81d6-9f433ac5f62a	15000	0bacdfd5-3a90-4f56-a18a-1463db82dcf9	2025-06-15 03:26:37.883854+00	4e42b7ac-5287-429c-983a-fb1defd8aa6d
0d5fa21e-d7a1-4226-8148-2c8bf18b8cec	5000	6417754b-b5f1-4eb4-bc73-13a52ff13190	2025-06-15 03:26:37.883854+00	d157f3d2-15a9-4980-a415-54e60a1eab3c
0d5fa21e-d7a1-4226-8148-2c8bf18b8cec	10000	7c309922-ae69-4235-96a2-0be19f69b52c	2025-06-15 03:26:37.883854+00	e5438a93-f9cf-4d79-a20e-eda85f191a6b
0d5fa21e-d7a1-4226-8148-2c8bf18b8cec	15000	751914bf-684c-4b75-a3f1-d160867a98bc	2025-06-15 03:26:37.883854+00	4e42b7ac-5287-429c-983a-fb1defd8aa6d
2b66b650-2c8e-4811-920f-ab655bd67ee3	6000	d7e3c5fe-a3ff-469b-8938-097f8abb8104	2025-06-15 12:21:35.856241+00	2c1d83ff-93d7-4f90-85f1-2bf004a22643
2b66b650-2c8e-4811-920f-ab655bd67ee3	8000	a487ea78-047d-4a66-8148-422db2e59a96	2025-06-15 12:21:35.856241+00	32a4579c-9cee-49c0-8be6-67274b5ab04d
2b66b650-2c8e-4811-920f-ab655bd67ee3	12000	3b64e581-cf33-417f-915d-1a57b6e7daca	2025-06-15 12:21:35.856241+00	6b9df17f-67f6-44f2-9ed3-19a993e50203
b1b93f8e-9ef3-4566-857f-c20f208d1997	4000	4daf35c6-00bc-45d8-b36f-1c46680b1592	2025-06-15 12:21:35.856241+00	2c1d83ff-93d7-4f90-85f1-2bf004a22643
b1b93f8e-9ef3-4566-857f-c20f208d1997	6000	bb44ac91-5f79-44fe-8908-eacf84e50d38	2025-06-15 12:21:35.856241+00	32a4579c-9cee-49c0-8be6-67274b5ab04d
b1b93f8e-9ef3-4566-857f-c20f208d1997	8000	b834c206-6b63-42f0-ba5d-733b789ba77d	2025-06-15 12:21:35.856241+00	6b9df17f-67f6-44f2-9ed3-19a993e50203
97daf8a4-49e8-47ed-b368-203b2c6fb3b8	20000	d356a411-9184-4812-9fde-b6abdf7181c4	2025-06-15 12:21:35.856241+00	2c1d83ff-93d7-4f90-85f1-2bf004a22643
97daf8a4-49e8-47ed-b368-203b2c6fb3b8	25000	ad8f4132-3de8-48e7-b3c9-957fc0cf7349	2025-06-15 12:21:35.856241+00	32a4579c-9cee-49c0-8be6-67274b5ab04d
97daf8a4-49e8-47ed-b368-203b2c6fb3b8	30000	5e4bd752-ee6c-4796-afd3-e7278187158c	2025-06-15 12:21:35.856241+00	6b9df17f-67f6-44f2-9ed3-19a993e50203
a9ffe775-9ad4-4def-ba00-13329020879f	30000	3422d80c-29db-44e4-9c75-f70869fa3cba	2025-06-15 12:21:35.856241+00	2c1d83ff-93d7-4f90-85f1-2bf004a22643
a9ffe775-9ad4-4def-ba00-13329020879f	20000	c45cdfae-4a08-4a85-9112-ecd320c54563	2025-06-15 12:21:35.856241+00	32a4579c-9cee-49c0-8be6-67274b5ab04d
a9ffe775-9ad4-4def-ba00-13329020879f	10000	796c96bb-fb5b-432f-a0f9-9f1495b88ca4	2025-06-15 12:21:35.856241+00	6b9df17f-67f6-44f2-9ed3-19a993e50203
fae3f751-3aa3-4f30-9349-77efd339427f	5000	a26d0944-5122-4ecb-a32b-20785104765d	2025-06-15 12:21:35.856241+00	2c1d83ff-93d7-4f90-85f1-2bf004a22643
fae3f751-3aa3-4f30-9349-77efd339427f	10000	4655f2f2-3097-4c97-9d96-3bc99f41dcca	2025-06-15 12:21:35.856241+00	32a4579c-9cee-49c0-8be6-67274b5ab04d
fae3f751-3aa3-4f30-9349-77efd339427f	15000	a87faa57-a6a2-41c3-b2a4-c46776e561a0	2025-06-15 12:21:35.856241+00	6b9df17f-67f6-44f2-9ed3-19a993e50203
7dce5d00-03fb-4700-a715-46f994929090	5000	139e85c5-b58c-4605-8ca1-998997349bc4	2025-06-15 12:21:35.856241+00	2c1d83ff-93d7-4f90-85f1-2bf004a22643
7dce5d00-03fb-4700-a715-46f994929090	10000	d0c6a83d-59cd-4964-908a-ba360d34728b	2025-06-15 12:21:35.856241+00	32a4579c-9cee-49c0-8be6-67274b5ab04d
7dce5d00-03fb-4700-a715-46f994929090	15000	c5ff50e2-1ee5-402b-8492-b47155610c96	2025-06-15 12:21:35.856241+00	6b9df17f-67f6-44f2-9ed3-19a993e50203
891e651e-0e12-4430-b1c3-af212d55d23d	6000	66830f36-d2ca-4161-872b-7a50a252bcef	2025-06-15 12:59:20.039467+00	914af688-3621-471b-86d2-613a793511a6
891e651e-0e12-4430-b1c3-af212d55d23d	8000	2a490cbb-ad02-4800-a314-4522335774a1	2025-06-15 12:59:20.039467+00	dae7d0aa-7898-4ea7-b8ae-50dff6d6122b
891e651e-0e12-4430-b1c3-af212d55d23d	12000	6c29df04-1047-4b90-aa47-7412b707b796	2025-06-15 12:59:20.039467+00	6324cdb5-ba69-4eef-bb04-6c248c1ceed3
3127ebea-6654-4db5-85be-108e2b276142	4000	89dd6236-b157-4fcc-a45b-63444ba0cb54	2025-06-15 12:59:20.039467+00	914af688-3621-471b-86d2-613a793511a6
3127ebea-6654-4db5-85be-108e2b276142	6000	d12e25b2-1d9c-4531-a477-c08725b04dc6	2025-06-15 12:59:20.039467+00	dae7d0aa-7898-4ea7-b8ae-50dff6d6122b
3127ebea-6654-4db5-85be-108e2b276142	8000	b9f705f4-6464-4b92-965b-4b5b4fe18d72	2025-06-15 12:59:20.039467+00	6324cdb5-ba69-4eef-bb04-6c248c1ceed3
e45f5b89-89bc-4ac6-b86e-322c30e44d8a	20000	5e2d97c1-a5a4-431f-b7cc-73bc3fbbe346	2025-06-15 12:59:20.039467+00	914af688-3621-471b-86d2-613a793511a6
e45f5b89-89bc-4ac6-b86e-322c30e44d8a	25000	2e0c0ef4-f7f6-4574-915e-c6570f8c362a	2025-06-15 12:59:20.039467+00	dae7d0aa-7898-4ea7-b8ae-50dff6d6122b
e45f5b89-89bc-4ac6-b86e-322c30e44d8a	30000	38f74c6e-401a-44a4-9416-50dfdf90a7bd	2025-06-15 12:59:20.039467+00	6324cdb5-ba69-4eef-bb04-6c248c1ceed3
1ae9377c-6951-4098-b234-68dc19d678fd	30000	eb419197-2d72-44e1-af72-04caf2d31945	2025-06-15 12:59:20.039467+00	914af688-3621-471b-86d2-613a793511a6
1ae9377c-6951-4098-b234-68dc19d678fd	20000	d46afda3-9786-4e90-970b-d4a1b4d63c59	2025-06-15 12:59:20.039467+00	dae7d0aa-7898-4ea7-b8ae-50dff6d6122b
1ae9377c-6951-4098-b234-68dc19d678fd	10000	9da141c8-1905-440c-80a1-4c68f5d47985	2025-06-15 12:59:20.039467+00	6324cdb5-ba69-4eef-bb04-6c248c1ceed3
7d0144f5-bc0e-4b34-9ba8-2f4fe1b6f078	5000	e880823d-b80d-4019-923f-f1a1ed2d0fd1	2025-06-15 12:59:20.039467+00	914af688-3621-471b-86d2-613a793511a6
7d0144f5-bc0e-4b34-9ba8-2f4fe1b6f078	10000	7703cd83-11f7-4069-9d5b-3ac05da6e144	2025-06-15 12:59:20.039467+00	dae7d0aa-7898-4ea7-b8ae-50dff6d6122b
7d0144f5-bc0e-4b34-9ba8-2f4fe1b6f078	15000	8fa2b10f-8f47-4d89-a704-c44def85bdfd	2025-06-15 12:59:20.039467+00	6324cdb5-ba69-4eef-bb04-6c248c1ceed3
50b72a4d-191b-4e5e-a06e-313b19cc6843	5000	4c0d6853-7cd6-414f-8444-5e1f27f0cb29	2025-06-15 12:59:20.039467+00	914af688-3621-471b-86d2-613a793511a6
50b72a4d-191b-4e5e-a06e-313b19cc6843	10000	200b5d0a-332d-4059-922d-41d1750dc1a7	2025-06-15 12:59:20.039467+00	dae7d0aa-7898-4ea7-b8ae-50dff6d6122b
50b72a4d-191b-4e5e-a06e-313b19cc6843	15000	a8e8a7f5-a88e-47f3-b657-ee5a2bdc0d17	2025-06-15 12:59:20.039467+00	6324cdb5-ba69-4eef-bb04-6c248c1ceed3
d545bb1b-ac98-4f13-a72e-5b7b05ed1153	6000	e18a62a0-1db8-4c29-8dbf-c6f494c7f223	2025-06-15 13:01:09.714034+00	c46ed9e9-a61b-4f06-9352-121791f69d9c
d545bb1b-ac98-4f13-a72e-5b7b05ed1153	8000	dc171d1b-5bf1-40af-990a-5d48583a65f3	2025-06-15 13:01:09.714034+00	93b34904-0165-4e45-96ba-934dd6cb85f5
d545bb1b-ac98-4f13-a72e-5b7b05ed1153	12000	a7525397-d831-46d4-94bb-d4c7ae7de5b5	2025-06-15 13:01:09.714034+00	3b3265e3-0c91-45cf-9686-f9abc1d28420
cc91eaa2-b419-44cc-864d-3784b703662c	4000	3058ca18-230a-4c60-873c-da36eb87ec14	2025-06-15 13:01:09.714034+00	c46ed9e9-a61b-4f06-9352-121791f69d9c
cc91eaa2-b419-44cc-864d-3784b703662c	6000	280c561b-7c2d-45db-ad11-cb88d0f4b3b1	2025-06-15 13:01:09.714034+00	93b34904-0165-4e45-96ba-934dd6cb85f5
cc91eaa2-b419-44cc-864d-3784b703662c	8000	64cbdf0b-9665-451a-97ee-275c050d0b7b	2025-06-15 13:01:09.714034+00	3b3265e3-0c91-45cf-9686-f9abc1d28420
364bf1b8-0aac-4f25-bf14-f0332172aba4	20000	70de8fc9-2323-474f-97b0-524a0c8d739e	2025-06-15 13:01:09.714034+00	c46ed9e9-a61b-4f06-9352-121791f69d9c
364bf1b8-0aac-4f25-bf14-f0332172aba4	25000	94d33c36-dcdd-4bfc-9ef2-b399c24e6c49	2025-06-15 13:01:09.714034+00	93b34904-0165-4e45-96ba-934dd6cb85f5
364bf1b8-0aac-4f25-bf14-f0332172aba4	30000	67c39b60-d00a-4cca-90d1-c9142325e6fc	2025-06-15 13:01:09.714034+00	3b3265e3-0c91-45cf-9686-f9abc1d28420
8c113aff-73db-4f3d-8d1c-3828a63ee21b	30000	6f7c65d6-4694-40e0-bf7a-cafc0bccdcd5	2025-06-15 13:01:09.714034+00	c46ed9e9-a61b-4f06-9352-121791f69d9c
8c113aff-73db-4f3d-8d1c-3828a63ee21b	20000	9cadd54b-c496-4dd7-8e73-4c9a94ffd1c4	2025-06-15 13:01:09.714034+00	93b34904-0165-4e45-96ba-934dd6cb85f5
8c113aff-73db-4f3d-8d1c-3828a63ee21b	10000	c121ab9e-2818-47bc-a343-8877bc3bcbf6	2025-06-15 13:01:09.714034+00	3b3265e3-0c91-45cf-9686-f9abc1d28420
2fe93373-098a-440f-9d39-5ee7916492ad	5000	8317f809-0b4b-4245-ba3d-24975a6e5995	2025-06-15 13:01:09.714034+00	c46ed9e9-a61b-4f06-9352-121791f69d9c
2fe93373-098a-440f-9d39-5ee7916492ad	10000	a0c7a450-156e-4d23-b1b3-7d56026d38ef	2025-06-15 13:01:09.714034+00	93b34904-0165-4e45-96ba-934dd6cb85f5
2fe93373-098a-440f-9d39-5ee7916492ad	15000	ac929da7-577b-4bc5-8823-ba29b3e077a0	2025-06-15 13:01:09.714034+00	3b3265e3-0c91-45cf-9686-f9abc1d28420
b4979747-b23c-4ba8-a123-d1753ccc234f	5000	608f9337-b36d-41ea-8b9d-74b97a45fa4d	2025-06-15 13:01:09.714034+00	c46ed9e9-a61b-4f06-9352-121791f69d9c
b4979747-b23c-4ba8-a123-d1753ccc234f	10000	834cf24c-e24b-4838-a1b9-73da878d1777	2025-06-15 13:01:09.714034+00	93b34904-0165-4e45-96ba-934dd6cb85f5
b4979747-b23c-4ba8-a123-d1753ccc234f	15000	9549d112-6968-418c-87cb-0588424453be	2025-06-15 13:01:09.714034+00	3b3265e3-0c91-45cf-9686-f9abc1d28420
b4b8ef64-8fe5-42a2-94f2-99a9435ab757	6000	46eb02d1-2690-48f4-94ac-4427239d2a4b	2025-06-16 14:43:24.217119+00	43fe47b2-4241-4b71-8ef1-e0bc5679be95
b4b8ef64-8fe5-42a2-94f2-99a9435ab757	8000	db7a5c03-0777-4e80-a9fb-ca91fbd13e5a	2025-06-16 14:43:24.217119+00	ca89f6b7-09f0-4976-8a59-a0f0003d33b9
b4b8ef64-8fe5-42a2-94f2-99a9435ab757	12000	fde6d312-2415-476a-88d4-e0dec9ecd440	2025-06-16 14:43:24.217119+00	be775625-f185-4a61-bab2-d1960ab9d299
21d54683-b734-439b-9d68-fe40ebef3444	4000	b2f47b59-05ca-454e-8f22-4955beeb90e9	2025-06-16 14:43:24.217119+00	43fe47b2-4241-4b71-8ef1-e0bc5679be95
21d54683-b734-439b-9d68-fe40ebef3444	6000	7a1ae15b-5d5c-44b6-b5bf-d9bd2c43d6fb	2025-06-16 14:43:24.217119+00	ca89f6b7-09f0-4976-8a59-a0f0003d33b9
21d54683-b734-439b-9d68-fe40ebef3444	8000	f7579c63-e696-4ec9-b25a-63926e84d36f	2025-06-16 14:43:24.217119+00	be775625-f185-4a61-bab2-d1960ab9d299
93c38c3e-ee57-45c1-b269-534b453d9c71	20000	2f0d3977-1c7b-45f0-9a38-ed7c16aeeac7	2025-06-16 14:43:24.217119+00	43fe47b2-4241-4b71-8ef1-e0bc5679be95
93c38c3e-ee57-45c1-b269-534b453d9c71	25000	a949031d-4ec7-4fed-9877-666ebc430546	2025-06-16 14:43:24.217119+00	ca89f6b7-09f0-4976-8a59-a0f0003d33b9
93c38c3e-ee57-45c1-b269-534b453d9c71	30000	33b885d7-9c14-4191-8f03-4c97bca7f81e	2025-06-16 14:43:24.217119+00	be775625-f185-4a61-bab2-d1960ab9d299
a21ac0cb-0b00-4c87-af2d-598de74989f6	30000	7648e8f2-b886-4b62-b9be-088e0d3bd97d	2025-06-16 14:43:24.217119+00	43fe47b2-4241-4b71-8ef1-e0bc5679be95
a21ac0cb-0b00-4c87-af2d-598de74989f6	20000	39a94bc9-f4dc-4b97-9680-7fa3672edc85	2025-06-16 14:43:24.217119+00	ca89f6b7-09f0-4976-8a59-a0f0003d33b9
a21ac0cb-0b00-4c87-af2d-598de74989f6	10000	21706580-e47b-47df-99c1-24bda90896c0	2025-06-16 14:43:24.217119+00	be775625-f185-4a61-bab2-d1960ab9d299
f68eb99f-9245-45e5-80f6-3f764fa9cada	5000	20952962-2d12-4783-a546-a4d75ee2ed07	2025-06-16 14:43:24.217119+00	43fe47b2-4241-4b71-8ef1-e0bc5679be95
f68eb99f-9245-45e5-80f6-3f764fa9cada	10000	ad2b4dde-ea59-4b38-95fb-0555780bf665	2025-06-16 14:43:24.217119+00	ca89f6b7-09f0-4976-8a59-a0f0003d33b9
f68eb99f-9245-45e5-80f6-3f764fa9cada	15000	da659e8a-62cd-49d6-81af-59a5eaa083db	2025-06-16 14:43:24.217119+00	be775625-f185-4a61-bab2-d1960ab9d299
c0026ce2-18a0-4f06-9e8c-07d124c2fd34	5000	271d6ab3-705f-4614-a12f-33da00b7a5f1	2025-06-16 14:43:24.217119+00	43fe47b2-4241-4b71-8ef1-e0bc5679be95
c0026ce2-18a0-4f06-9e8c-07d124c2fd34	10000	e968d93b-7224-4483-8580-5d119f75cca7	2025-06-16 14:43:24.217119+00	ca89f6b7-09f0-4976-8a59-a0f0003d33b9
c0026ce2-18a0-4f06-9e8c-07d124c2fd34	15000	88d33e03-cf36-4707-abcd-462911089ec3	2025-06-16 14:43:24.217119+00	be775625-f185-4a61-bab2-d1960ab9d299
b04f1cc6-e2bb-40d8-9325-42928f9dd843	6000	c5dd8baf-800e-4b53-9ec9-c805cf6fe62a	2025-07-07 15:47:09.223472+00	e4f5dedd-3256-49a5-9616-d66aea786692
b04f1cc6-e2bb-40d8-9325-42928f9dd843	8000	1649f537-e377-4eac-bac1-1ac111f21bd3	2025-07-07 15:47:09.223472+00	bb84644d-b0a2-431e-8aa1-4c86eb028f6a
b04f1cc6-e2bb-40d8-9325-42928f9dd843	12000	fe3d3e74-688a-4f33-82cd-c52d72a13aa6	2025-07-07 15:47:09.223472+00	9a4a0732-9cb1-4d86-82d9-b8da6ce8f1ba
322677a6-24d9-44b5-bae9-7ebe6a97cdc8	4000	f08178c1-3764-4d49-807c-2d9aca84bc50	2025-07-07 15:47:09.223472+00	e4f5dedd-3256-49a5-9616-d66aea786692
322677a6-24d9-44b5-bae9-7ebe6a97cdc8	6000	91670113-4953-4469-9fc7-feb1e02344a7	2025-07-07 15:47:09.223472+00	bb84644d-b0a2-431e-8aa1-4c86eb028f6a
322677a6-24d9-44b5-bae9-7ebe6a97cdc8	8000	3549be4d-b0c2-4a4a-af27-0236dd9b6288	2025-07-07 15:47:09.223472+00	9a4a0732-9cb1-4d86-82d9-b8da6ce8f1ba
cb183076-c13e-46d5-950f-b40c7e7331b5	20000	fa1e6504-7ee5-4ec7-9889-013905e4cb20	2025-07-07 15:47:09.223472+00	e4f5dedd-3256-49a5-9616-d66aea786692
cb183076-c13e-46d5-950f-b40c7e7331b5	25000	b29b2434-4c29-4ef7-b4b0-cb9e40a4cd2c	2025-07-07 15:47:09.223472+00	bb84644d-b0a2-431e-8aa1-4c86eb028f6a
cb183076-c13e-46d5-950f-b40c7e7331b5	30000	81ae3be0-d837-46d7-81eb-942bf596e8c9	2025-07-07 15:47:09.223472+00	9a4a0732-9cb1-4d86-82d9-b8da6ce8f1ba
954af9ed-e97e-4f6c-a03f-d47cd9cca4c5	30000	8e1e8f1e-057c-44a5-9fcb-d3d67fe6f00b	2025-07-07 15:47:09.223472+00	e4f5dedd-3256-49a5-9616-d66aea786692
954af9ed-e97e-4f6c-a03f-d47cd9cca4c5	20000	bc39ba2f-d505-4861-9384-6e4833c5b8d5	2025-07-07 15:47:09.223472+00	bb84644d-b0a2-431e-8aa1-4c86eb028f6a
954af9ed-e97e-4f6c-a03f-d47cd9cca4c5	10000	ee59ef88-c8ca-4050-953a-3e04ab99ad4c	2025-07-07 15:47:09.223472+00	9a4a0732-9cb1-4d86-82d9-b8da6ce8f1ba
507b7670-cc47-414d-9bb5-9fcf58b3e9dc	5000	583c856a-5de8-4969-be72-32aa2874c4fb	2025-07-07 15:47:09.223472+00	e4f5dedd-3256-49a5-9616-d66aea786692
507b7670-cc47-414d-9bb5-9fcf58b3e9dc	10000	5016f6fb-3e57-4a57-a1a0-ba86bc7515ea	2025-07-07 15:47:09.223472+00	bb84644d-b0a2-431e-8aa1-4c86eb028f6a
507b7670-cc47-414d-9bb5-9fcf58b3e9dc	15000	74888e82-4419-4456-a527-b9a496743b34	2025-07-07 15:47:09.223472+00	9a4a0732-9cb1-4d86-82d9-b8da6ce8f1ba
e43fa975-cf34-4a64-958b-940f88a73227	5000	990121af-fca6-448a-8449-d7017ab0ace1	2025-07-07 15:47:09.223472+00	e4f5dedd-3256-49a5-9616-d66aea786692
e43fa975-cf34-4a64-958b-940f88a73227	10000	a10e8dbf-5f20-4054-95ee-eca34dcd4cbe	2025-07-07 15:47:09.223472+00	bb84644d-b0a2-431e-8aa1-4c86eb028f6a
e43fa975-cf34-4a64-958b-940f88a73227	15000	abf407c9-a02e-4b3d-aa9c-5c8491f37a88	2025-07-07 15:47:09.223472+00	9a4a0732-9cb1-4d86-82d9-b8da6ce8f1ba
ca92e0e1-d78d-47a2-afab-5d7719fe471a	6000	3460617d-616f-4c13-a20d-faf862729a8b	2025-07-07 15:52:34.649154+00	399fda41-db45-47c8-9427-87211f005799
ca92e0e1-d78d-47a2-afab-5d7719fe471a	8000	97ba8e55-0f2b-4b4c-b315-99e2c72facda	2025-07-07 15:52:34.649154+00	41ed5c1b-6152-4627-a975-e45516661bad
ca92e0e1-d78d-47a2-afab-5d7719fe471a	12000	7b0333e7-a9bc-4a06-b539-000a5ab93470	2025-07-07 15:52:34.649154+00	c4ef3627-a78b-4eb2-a2e6-ffe43e3657aa
6d967eb3-c69b-45ed-9f0d-785eaf478776	4000	d159c2d8-f3cc-4e77-ae8e-a9688e87c2d2	2025-07-07 15:52:34.649154+00	399fda41-db45-47c8-9427-87211f005799
6d967eb3-c69b-45ed-9f0d-785eaf478776	6000	14039930-e6be-440a-b307-f17a50c354e8	2025-07-07 15:52:34.649154+00	41ed5c1b-6152-4627-a975-e45516661bad
6d967eb3-c69b-45ed-9f0d-785eaf478776	8000	2080e754-d439-45be-a0f0-6e8001d30b65	2025-07-07 15:52:34.649154+00	c4ef3627-a78b-4eb2-a2e6-ffe43e3657aa
ef3cefca-6c2c-4dc8-96b8-5751d205cca6	20000	2e7ac0a7-7be8-44d7-925e-f23b29db5265	2025-07-07 15:52:34.649154+00	399fda41-db45-47c8-9427-87211f005799
ef3cefca-6c2c-4dc8-96b8-5751d205cca6	25000	a93f2132-fa13-4dfb-9faf-c6580366cd89	2025-07-07 15:52:34.649154+00	41ed5c1b-6152-4627-a975-e45516661bad
ef3cefca-6c2c-4dc8-96b8-5751d205cca6	30000	a149c8e1-494b-42c9-be39-43ddc0214334	2025-07-07 15:52:34.649154+00	c4ef3627-a78b-4eb2-a2e6-ffe43e3657aa
f91570c4-ff18-476d-b07c-ff4a863e4241	30000	baa773a0-fa02-4332-add1-6d213b2544e7	2025-07-07 15:52:34.649154+00	399fda41-db45-47c8-9427-87211f005799
f91570c4-ff18-476d-b07c-ff4a863e4241	20000	13739e62-5f6a-4646-9c97-09aaef6da21d	2025-07-07 15:52:34.649154+00	41ed5c1b-6152-4627-a975-e45516661bad
f91570c4-ff18-476d-b07c-ff4a863e4241	10000	ab04ee8c-1738-4ede-abf1-fcdd134cd6f2	2025-07-07 15:52:34.649154+00	c4ef3627-a78b-4eb2-a2e6-ffe43e3657aa
7e661673-7306-4c22-b723-dec45e620a5e	5000	834f341f-b13b-492b-91c3-9134b49d38ad	2025-07-07 15:52:34.649154+00	399fda41-db45-47c8-9427-87211f005799
7e661673-7306-4c22-b723-dec45e620a5e	10000	c9e0d877-4795-4f8d-9d66-08670d8cbf10	2025-07-07 15:52:34.649154+00	41ed5c1b-6152-4627-a975-e45516661bad
7e661673-7306-4c22-b723-dec45e620a5e	15000	0db18dcb-8659-4ee5-af58-0afa6450e10c	2025-07-07 15:52:34.649154+00	c4ef3627-a78b-4eb2-a2e6-ffe43e3657aa
3862bc8b-7bbb-4d25-95cf-25964cefcd62	5000	36752453-0da0-4fba-a7f2-408096640b06	2025-07-07 15:52:34.649154+00	399fda41-db45-47c8-9427-87211f005799
3862bc8b-7bbb-4d25-95cf-25964cefcd62	10000	8c8f4d2e-28b8-4e9f-8034-0284b11ee729	2025-07-07 15:52:34.649154+00	41ed5c1b-6152-4627-a975-e45516661bad
3862bc8b-7bbb-4d25-95cf-25964cefcd62	15000	1ed8456d-9d59-4253-8bdc-ef5f83242d04	2025-07-07 15:52:34.649154+00	c4ef3627-a78b-4eb2-a2e6-ffe43e3657aa
70184a9b-e8a9-4e4b-905a-0aa2b470a4de	6000	04e852ab-7c7a-41fc-a391-9b51785f6c07	2025-07-07 15:53:35.479432+00	7969a2ea-01d6-4b93-a621-4894087f038e
70184a9b-e8a9-4e4b-905a-0aa2b470a4de	8000	1b5317c8-1a85-4cd7-a337-7e3ac04facf8	2025-07-07 15:53:35.479432+00	10697aed-f25b-4946-92b0-cbc6eede5738
70184a9b-e8a9-4e4b-905a-0aa2b470a4de	12000	985badff-cc96-4f36-bcf2-3d0985ba43a5	2025-07-07 15:53:35.479432+00	3e588837-472e-48ef-a8f2-5d6947777333
ec6450f2-6945-4204-a4fc-75afc2750faf	4000	067268e1-6e5d-4dee-9d20-7a074eb88b54	2025-07-07 15:53:35.479432+00	7969a2ea-01d6-4b93-a621-4894087f038e
ec6450f2-6945-4204-a4fc-75afc2750faf	6000	bebc3d6a-74ad-4a66-91d0-4f25d9940cf6	2025-07-07 15:53:35.479432+00	10697aed-f25b-4946-92b0-cbc6eede5738
ec6450f2-6945-4204-a4fc-75afc2750faf	8000	b00479f8-7d27-4501-91cc-7b875f567e4b	2025-07-07 15:53:35.479432+00	3e588837-472e-48ef-a8f2-5d6947777333
9a263a46-ad46-4176-8012-aa43f69ce7d6	20000	dc5fca8b-65cf-43ef-b048-98e4378e97d5	2025-07-07 15:53:35.479432+00	7969a2ea-01d6-4b93-a621-4894087f038e
9a263a46-ad46-4176-8012-aa43f69ce7d6	25000	167f7542-ea3b-4972-b1b3-e13c505da079	2025-07-07 15:53:35.479432+00	10697aed-f25b-4946-92b0-cbc6eede5738
9a263a46-ad46-4176-8012-aa43f69ce7d6	30000	9de9f672-f911-44bf-8049-39010178568e	2025-07-07 15:53:35.479432+00	3e588837-472e-48ef-a8f2-5d6947777333
5a7c204c-8d48-414c-90a7-e45d2d3b40a6	30000	e00f787f-aaf9-47b1-8018-136e35a1345b	2025-07-07 15:53:35.479432+00	7969a2ea-01d6-4b93-a621-4894087f038e
5a7c204c-8d48-414c-90a7-e45d2d3b40a6	20000	1b0e7d62-c51e-4cde-b388-ee18304d5598	2025-07-07 15:53:35.479432+00	10697aed-f25b-4946-92b0-cbc6eede5738
5a7c204c-8d48-414c-90a7-e45d2d3b40a6	10000	a6c7c2a8-1fae-4d26-8cf3-7dd63126c69d	2025-07-07 15:53:35.479432+00	3e588837-472e-48ef-a8f2-5d6947777333
512178c7-06f0-477c-8f52-adb10b91aa77	5000	52039e44-89dc-426e-a538-4c061fa1a445	2025-07-07 15:53:35.479432+00	7969a2ea-01d6-4b93-a621-4894087f038e
512178c7-06f0-477c-8f52-adb10b91aa77	10000	10bde766-2af2-4993-9b59-af7c1848f890	2025-07-07 15:53:35.479432+00	10697aed-f25b-4946-92b0-cbc6eede5738
512178c7-06f0-477c-8f52-adb10b91aa77	15000	875e3071-e821-402d-b097-4ef145cd16a6	2025-07-07 15:53:35.479432+00	3e588837-472e-48ef-a8f2-5d6947777333
5596366b-8d85-42a0-807d-3ac88cdd8fa6	5000	e45fe9ee-37c6-4407-ad18-1b2638b4e622	2025-07-07 15:53:35.479432+00	7969a2ea-01d6-4b93-a621-4894087f038e
5596366b-8d85-42a0-807d-3ac88cdd8fa6	10000	9aefcef3-1092-42f7-8d1c-676251c82170	2025-07-07 15:53:35.479432+00	10697aed-f25b-4946-92b0-cbc6eede5738
5596366b-8d85-42a0-807d-3ac88cdd8fa6	15000	458e72fe-057b-43a1-9f05-e7c3e422c64e	2025-07-07 15:53:35.479432+00	3e588837-472e-48ef-a8f2-5d6947777333
89bd638f-9ddf-48c9-8b64-70ad6a61e7e5	6000	6e7c647f-2b2e-4583-87c3-bd171c8a4487	2025-07-07 15:55:46.553254+00	a530e441-da5b-406d-8b02-24c5a84df009
89bd638f-9ddf-48c9-8b64-70ad6a61e7e5	8000	5dea4697-1388-489b-b7f0-2dd22fc51d44	2025-07-07 15:55:46.553254+00	dc7c1a05-41c8-4db7-b5e6-2839979e8afd
89bd638f-9ddf-48c9-8b64-70ad6a61e7e5	12000	f527a95b-5c97-4023-9a99-af434d447c15	2025-07-07 15:55:46.553254+00	3ccb4563-f802-4c48-9bea-94d47cc8a655
5eb3b193-a83e-4d89-893e-cb4573accd16	4000	87226807-014c-4c48-a927-a05a2ef26a42	2025-07-07 15:55:46.553254+00	a530e441-da5b-406d-8b02-24c5a84df009
5eb3b193-a83e-4d89-893e-cb4573accd16	6000	b999085c-2aef-44c6-94c9-8894570bca44	2025-07-07 15:55:46.553254+00	dc7c1a05-41c8-4db7-b5e6-2839979e8afd
5eb3b193-a83e-4d89-893e-cb4573accd16	8000	6f5a9530-15f6-4204-92ec-cbeb811ff268	2025-07-07 15:55:46.553254+00	3ccb4563-f802-4c48-9bea-94d47cc8a655
6443e4d6-b802-4ce8-92d9-369fcbf1fb8f	20000	b82bb751-a907-4524-b851-07e6050322b7	2025-07-07 15:55:46.553254+00	a530e441-da5b-406d-8b02-24c5a84df009
6443e4d6-b802-4ce8-92d9-369fcbf1fb8f	25000	238e61dc-af08-462a-9b93-67fad212f13b	2025-07-07 15:55:46.553254+00	dc7c1a05-41c8-4db7-b5e6-2839979e8afd
6443e4d6-b802-4ce8-92d9-369fcbf1fb8f	30000	f76f29f9-756f-4dc4-9287-51b6aec37620	2025-07-07 15:55:46.553254+00	3ccb4563-f802-4c48-9bea-94d47cc8a655
ccb21722-0e3c-418b-9570-1ade1609022c	30000	bc980be3-1021-4476-950f-e2064ad0bbbc	2025-07-07 15:55:46.553254+00	a530e441-da5b-406d-8b02-24c5a84df009
ccb21722-0e3c-418b-9570-1ade1609022c	20000	5e243925-72ee-4246-82ff-a81553502e7d	2025-07-07 15:55:46.553254+00	dc7c1a05-41c8-4db7-b5e6-2839979e8afd
ccb21722-0e3c-418b-9570-1ade1609022c	10000	b8bcb2dd-b013-4311-a81a-60d70f7dab36	2025-07-07 15:55:46.553254+00	3ccb4563-f802-4c48-9bea-94d47cc8a655
c65f66a3-d6ce-446b-8a91-a76f1fc18f0d	5000	f79a8f61-bed9-424f-920c-447bddc5d512	2025-07-07 15:55:46.553254+00	a530e441-da5b-406d-8b02-24c5a84df009
c65f66a3-d6ce-446b-8a91-a76f1fc18f0d	10000	57a2c25b-a2a2-4d44-8541-d6eed0a46064	2025-07-07 15:55:46.553254+00	dc7c1a05-41c8-4db7-b5e6-2839979e8afd
c65f66a3-d6ce-446b-8a91-a76f1fc18f0d	15000	2c67ea8b-93af-4171-b08b-d9bac2813fbc	2025-07-07 15:55:46.553254+00	3ccb4563-f802-4c48-9bea-94d47cc8a655
8641d73b-2391-476f-8cb9-f1118fba3745	5000	dcc49549-a4ad-40f1-a994-307c4e90c0e7	2025-07-07 15:55:46.553254+00	a530e441-da5b-406d-8b02-24c5a84df009
8641d73b-2391-476f-8cb9-f1118fba3745	10000	241df5f5-e07d-4cd7-ab6e-1f198208075b	2025-07-07 15:55:46.553254+00	dc7c1a05-41c8-4db7-b5e6-2839979e8afd
8641d73b-2391-476f-8cb9-f1118fba3745	15000	e7c4df8a-a3b5-41c3-97a9-ce4f2ee39ba8	2025-07-07 15:55:46.553254+00	3ccb4563-f802-4c48-9bea-94d47cc8a655
2ff9f826-8329-456b-bc3e-ac01d15927b3	6000	fe9c0dc6-f04a-4864-b808-cc60c1172d3e	2025-07-07 15:57:48.951669+00	83de63a1-806c-44b8-93ac-008b67936d9d
2ff9f826-8329-456b-bc3e-ac01d15927b3	8000	0ee71bb0-77c8-4aa4-bede-c1d82a880bd1	2025-07-07 15:57:48.951669+00	0a504ac5-d2cc-4767-9de4-377d7e5a36b3
2ff9f826-8329-456b-bc3e-ac01d15927b3	12000	1c806c76-7ee0-4f3c-9eca-2b149de1dc81	2025-07-07 15:57:48.951669+00	9d06e6e7-1ebb-44f9-bd64-75daa260baaa
7a567a14-ce52-40e6-8051-0fabfd380292	4000	799857ff-7e84-499c-9d9b-ff8f2637612b	2025-07-07 15:57:48.951669+00	83de63a1-806c-44b8-93ac-008b67936d9d
7a567a14-ce52-40e6-8051-0fabfd380292	6000	b3a18a72-157c-4f4e-b59c-2abf517c313d	2025-07-07 15:57:48.951669+00	0a504ac5-d2cc-4767-9de4-377d7e5a36b3
7a567a14-ce52-40e6-8051-0fabfd380292	8000	12116144-7d87-4361-a394-515c764b97cf	2025-07-07 15:57:48.951669+00	9d06e6e7-1ebb-44f9-bd64-75daa260baaa
2b47a857-0b5e-462c-8f8e-a4f5d3f3f497	20000	85e0e943-2faf-4d37-bf91-dae5178d4acf	2025-07-07 15:57:48.951669+00	83de63a1-806c-44b8-93ac-008b67936d9d
2b47a857-0b5e-462c-8f8e-a4f5d3f3f497	25000	895d5cb4-935c-4d99-848a-0633f256174f	2025-07-07 15:57:48.951669+00	0a504ac5-d2cc-4767-9de4-377d7e5a36b3
2b47a857-0b5e-462c-8f8e-a4f5d3f3f497	30000	e2d6e6e7-aa93-474f-a87f-e830ef5a8e24	2025-07-07 15:57:48.951669+00	9d06e6e7-1ebb-44f9-bd64-75daa260baaa
956913d4-f543-4e2d-b08a-a7cf2e56c124	30000	079d5db3-f732-41be-9606-b7e3df853347	2025-07-07 15:57:48.951669+00	83de63a1-806c-44b8-93ac-008b67936d9d
956913d4-f543-4e2d-b08a-a7cf2e56c124	20000	026fe4ea-98be-445e-98e4-b612d0ab2d96	2025-07-07 15:57:48.951669+00	0a504ac5-d2cc-4767-9de4-377d7e5a36b3
956913d4-f543-4e2d-b08a-a7cf2e56c124	10000	d86e6c15-56bd-44bd-9377-12e426cffc3c	2025-07-07 15:57:48.951669+00	9d06e6e7-1ebb-44f9-bd64-75daa260baaa
f0721182-ab7e-4834-90e4-d8a3114244bc	5000	a38d98bb-e273-48c8-82b9-8ecfb39be302	2025-07-07 15:57:48.951669+00	83de63a1-806c-44b8-93ac-008b67936d9d
f0721182-ab7e-4834-90e4-d8a3114244bc	10000	94eab061-7e94-4e26-975a-ebf7e5cf2f7d	2025-07-07 15:57:48.951669+00	0a504ac5-d2cc-4767-9de4-377d7e5a36b3
f0721182-ab7e-4834-90e4-d8a3114244bc	15000	5c08813d-2a71-4d11-8392-bbc3a5c37250	2025-07-07 15:57:48.951669+00	9d06e6e7-1ebb-44f9-bd64-75daa260baaa
a123c696-294c-433f-ad52-3b60ddbac1b1	5000	4fe4fe3e-811b-486e-bcdd-931bd50822af	2025-07-07 15:57:48.951669+00	83de63a1-806c-44b8-93ac-008b67936d9d
a123c696-294c-433f-ad52-3b60ddbac1b1	10000	eec2f425-6ce6-4da0-9844-52ff14daf154	2025-07-07 15:57:48.951669+00	0a504ac5-d2cc-4767-9de4-377d7e5a36b3
a123c696-294c-433f-ad52-3b60ddbac1b1	15000	8731f0ee-3169-4da0-b707-91180b79460f	2025-07-07 15:57:48.951669+00	9d06e6e7-1ebb-44f9-bd64-75daa260baaa
15ac6a8c-a5e1-4cb1-95ff-cea105ee7c32	6000	5450b513-85d9-4360-b02c-7ee106feedd1	2025-07-07 16:03:08.483403+00	13aa807b-7bef-4c39-80c4-180e0a9142e5
15ac6a8c-a5e1-4cb1-95ff-cea105ee7c32	8000	d25599cf-59eb-4861-99fa-5ab51b9affaa	2025-07-07 16:03:08.483403+00	cea68088-696f-4107-adcd-90afb20b4b09
15ac6a8c-a5e1-4cb1-95ff-cea105ee7c32	12000	778c036b-c50f-44e6-9fc6-85789900a5ed	2025-07-07 16:03:08.483403+00	28bac44d-85c7-4cd5-aa9c-81083b4451dc
07bc69c7-9b1d-42bf-9ccd-b25968fd97df	4000	c40a2574-e37b-40a9-8da2-adb65fdd1c96	2025-07-07 16:03:08.483403+00	13aa807b-7bef-4c39-80c4-180e0a9142e5
07bc69c7-9b1d-42bf-9ccd-b25968fd97df	6000	26d369fc-e866-4b2c-b447-c9cd2ca533d4	2025-07-07 16:03:08.483403+00	cea68088-696f-4107-adcd-90afb20b4b09
07bc69c7-9b1d-42bf-9ccd-b25968fd97df	8000	afd2306a-3f50-4c14-89c3-974407a05214	2025-07-07 16:03:08.483403+00	28bac44d-85c7-4cd5-aa9c-81083b4451dc
24e0f7bd-6c7f-4ab4-93e6-1e2c4f56cf92	20000	8d879055-b66a-4341-8918-c8ea5a8cbf1e	2025-07-07 16:03:08.483403+00	13aa807b-7bef-4c39-80c4-180e0a9142e5
24e0f7bd-6c7f-4ab4-93e6-1e2c4f56cf92	25000	d95fd670-fc97-4512-826f-6172fd7ba309	2025-07-07 16:03:08.483403+00	cea68088-696f-4107-adcd-90afb20b4b09
24e0f7bd-6c7f-4ab4-93e6-1e2c4f56cf92	30000	155f833f-77fe-4adc-8d56-16b2321649fe	2025-07-07 16:03:08.483403+00	28bac44d-85c7-4cd5-aa9c-81083b4451dc
e8378f27-4529-4ab4-a5cd-33bb70112fae	30000	1d61b276-c489-44f4-948c-ad64ff8805c2	2025-07-07 16:03:08.483403+00	13aa807b-7bef-4c39-80c4-180e0a9142e5
e8378f27-4529-4ab4-a5cd-33bb70112fae	20000	9a3445ce-5001-4860-a1b9-396c34e18529	2025-07-07 16:03:08.483403+00	cea68088-696f-4107-adcd-90afb20b4b09
e8378f27-4529-4ab4-a5cd-33bb70112fae	10000	5554be5d-b72d-4578-b166-d1b405858e57	2025-07-07 16:03:08.483403+00	28bac44d-85c7-4cd5-aa9c-81083b4451dc
80fecff3-0bbc-45e4-a801-8c0ab99556af	5000	103f600a-b4ab-46d3-ae7e-7134ae4ce9b7	2025-07-07 16:03:08.483403+00	13aa807b-7bef-4c39-80c4-180e0a9142e5
80fecff3-0bbc-45e4-a801-8c0ab99556af	10000	c994df8d-7027-49df-a4d5-cb1f61f6cf9b	2025-07-07 16:03:08.483403+00	cea68088-696f-4107-adcd-90afb20b4b09
80fecff3-0bbc-45e4-a801-8c0ab99556af	15000	7a394308-9795-4462-adf7-a6b6103b883b	2025-07-07 16:03:08.483403+00	28bac44d-85c7-4cd5-aa9c-81083b4451dc
45ddc269-c50c-464a-8fe4-56dcd2b5ced2	5000	8d3b2726-26df-44a9-b163-816145385ece	2025-07-07 16:03:08.483403+00	13aa807b-7bef-4c39-80c4-180e0a9142e5
45ddc269-c50c-464a-8fe4-56dcd2b5ced2	10000	e5276e76-182d-4268-91c6-3e15026f224e	2025-07-07 16:03:08.483403+00	cea68088-696f-4107-adcd-90afb20b4b09
45ddc269-c50c-464a-8fe4-56dcd2b5ced2	15000	42c80992-31b9-40b9-9cd4-91d67f3f8e7b	2025-07-07 16:03:08.483403+00	28bac44d-85c7-4cd5-aa9c-81083b4451dc
be7085a5-b52b-4544-b3b2-4e306e8223c7	6000	48d6d2bd-5f4e-4a42-9e87-988a877f58fe	2025-07-12 05:40:22.296645+00	214c3961-54aa-4402-828e-9bf97523207e
be7085a5-b52b-4544-b3b2-4e306e8223c7	8000	a7ef41bb-8f23-4d1b-bf91-d2bd7afb5ebf	2025-07-12 05:40:22.296645+00	a5e60f66-46bc-4eb2-b394-7b6177f9e8d5
be7085a5-b52b-4544-b3b2-4e306e8223c7	12000	691e055d-40a5-416d-ac15-5ae6882491e5	2025-07-12 05:40:22.296645+00	680f103d-bcbf-4c7a-8d69-707756b1cda8
d95ccefa-a340-4319-a150-11898b9f7d8f	4000	e850ffba-5317-4c16-9a5a-4730010e376f	2025-07-12 05:40:22.296645+00	214c3961-54aa-4402-828e-9bf97523207e
d95ccefa-a340-4319-a150-11898b9f7d8f	6000	f35c4efe-e614-4bf9-8b1c-b2415ade41c7	2025-07-12 05:40:22.296645+00	a5e60f66-46bc-4eb2-b394-7b6177f9e8d5
d95ccefa-a340-4319-a150-11898b9f7d8f	8000	fae5d2b2-69b2-4655-b3bc-c6f2e50e18bc	2025-07-12 05:40:22.296645+00	680f103d-bcbf-4c7a-8d69-707756b1cda8
8e1225c5-f1f3-4adb-87d5-316321c48730	20000	b5d7c736-f7f3-4451-88a5-8e9f01ab2310	2025-07-12 05:40:22.296645+00	214c3961-54aa-4402-828e-9bf97523207e
8e1225c5-f1f3-4adb-87d5-316321c48730	25000	ffe54dbc-80aa-4ff5-bfcf-3016c8d956f0	2025-07-12 05:40:22.296645+00	a5e60f66-46bc-4eb2-b394-7b6177f9e8d5
8e1225c5-f1f3-4adb-87d5-316321c48730	30000	0b9eda7f-8918-48a7-b231-1ba09a664e35	2025-07-12 05:40:22.296645+00	680f103d-bcbf-4c7a-8d69-707756b1cda8
d6b2a483-4c8e-4471-a044-225fccbac7d1	30000	358a9670-bb34-4062-9f42-0844d4e941d5	2025-07-12 05:40:22.296645+00	214c3961-54aa-4402-828e-9bf97523207e
d6b2a483-4c8e-4471-a044-225fccbac7d1	20000	37b0273e-0ae3-4a6a-8357-3133d4c3e618	2025-07-12 05:40:22.296645+00	a5e60f66-46bc-4eb2-b394-7b6177f9e8d5
d6b2a483-4c8e-4471-a044-225fccbac7d1	10000	8a8021b6-327c-41fd-ba7c-430d6756c191	2025-07-12 05:40:22.296645+00	680f103d-bcbf-4c7a-8d69-707756b1cda8
8c9dd674-bd3c-4a1c-8427-6774876c9a73	5000	985f17f2-b6fe-4598-b89c-05605ad5cb5a	2025-07-12 05:40:22.296645+00	214c3961-54aa-4402-828e-9bf97523207e
8c9dd674-bd3c-4a1c-8427-6774876c9a73	10000	4586bdff-df89-491f-99c1-16148c709d12	2025-07-12 05:40:22.296645+00	a5e60f66-46bc-4eb2-b394-7b6177f9e8d5
8c9dd674-bd3c-4a1c-8427-6774876c9a73	15000	0d550d27-5322-4bb9-828a-9bee432fac27	2025-07-12 05:40:22.296645+00	680f103d-bcbf-4c7a-8d69-707756b1cda8
5ded865e-2b00-46bb-b9c4-0cd9f53e3a8b	5000	d90ae587-f0ed-4578-8b96-e14c90cbbf0a	2025-07-12 05:40:22.296645+00	214c3961-54aa-4402-828e-9bf97523207e
5ded865e-2b00-46bb-b9c4-0cd9f53e3a8b	10000	601d7977-8601-4b85-ac73-2fd068ca10a9	2025-07-12 05:40:22.296645+00	a5e60f66-46bc-4eb2-b394-7b6177f9e8d5
5ded865e-2b00-46bb-b9c4-0cd9f53e3a8b	15000	5fc8e8d0-189f-4ff0-9c4c-d796a315fae8	2025-07-12 05:40:22.296645+00	680f103d-bcbf-4c7a-8d69-707756b1cda8
7229c439-d63f-42bb-b943-e62cd7afe08f	6000	73cc93e6-7841-4d2d-b86f-e4276d6ff242	2025-07-12 05:52:39.653711+00	ca9b4d87-89bd-4ff9-9da5-d4b2f81db5e8
7229c439-d63f-42bb-b943-e62cd7afe08f	8000	bf9358ba-e1f6-4366-880e-9e867c06a71e	2025-07-12 05:52:39.653711+00	158250da-8379-4ed5-95c3-10e661ac4c16
7229c439-d63f-42bb-b943-e62cd7afe08f	12000	4d2f1b50-1d47-4ff6-ba70-f0ee75a3c3ad	2025-07-12 05:52:39.653711+00	4ab6a96b-3fa9-4b86-80b8-b28f98508d00
e15293ca-ccf2-42b1-a9c8-319787f08c18	4000	41841a31-8841-421c-8d4c-1b0abb2ac794	2025-07-12 05:52:39.653711+00	ca9b4d87-89bd-4ff9-9da5-d4b2f81db5e8
e15293ca-ccf2-42b1-a9c8-319787f08c18	6000	d9639583-f564-42c3-8144-877883a7461b	2025-07-12 05:52:39.653711+00	158250da-8379-4ed5-95c3-10e661ac4c16
e15293ca-ccf2-42b1-a9c8-319787f08c18	8000	834824c3-8b84-41ca-918e-1a6653161033	2025-07-12 05:52:39.653711+00	4ab6a96b-3fa9-4b86-80b8-b28f98508d00
9596a69f-d713-4e24-becf-15236e81182f	20000	2e6fdc42-a867-4dc8-b2b1-fda4377abe1f	2025-07-12 05:52:39.653711+00	ca9b4d87-89bd-4ff9-9da5-d4b2f81db5e8
9596a69f-d713-4e24-becf-15236e81182f	25000	d614102c-567a-4285-af7d-dc35530af8f6	2025-07-12 05:52:39.653711+00	158250da-8379-4ed5-95c3-10e661ac4c16
9596a69f-d713-4e24-becf-15236e81182f	30000	23a42ff0-9a12-48b0-92bc-c7b5f1a10f97	2025-07-12 05:52:39.653711+00	4ab6a96b-3fa9-4b86-80b8-b28f98508d00
fff35020-b4de-4963-825a-cf47c4ec260a	30000	ba9ed137-e06c-4479-a0d5-aa6eccdbcdec	2025-07-12 05:52:39.653711+00	ca9b4d87-89bd-4ff9-9da5-d4b2f81db5e8
fff35020-b4de-4963-825a-cf47c4ec260a	20000	34465a31-ed81-4f63-a82d-c61a201da083	2025-07-12 05:52:39.653711+00	158250da-8379-4ed5-95c3-10e661ac4c16
fff35020-b4de-4963-825a-cf47c4ec260a	10000	8cfc1d85-3bb4-4397-b7bb-fb26f45297a4	2025-07-12 05:52:39.653711+00	4ab6a96b-3fa9-4b86-80b8-b28f98508d00
2f3a52e7-3c9e-4b2d-a7bf-ebe9a71e606f	5000	d38ca47e-5bd1-4a08-b72c-abb501325f98	2025-07-12 05:52:39.653711+00	ca9b4d87-89bd-4ff9-9da5-d4b2f81db5e8
2f3a52e7-3c9e-4b2d-a7bf-ebe9a71e606f	10000	8e20ecc1-b153-41ff-8063-8fa2398b4af6	2025-07-12 05:52:39.653711+00	158250da-8379-4ed5-95c3-10e661ac4c16
2f3a52e7-3c9e-4b2d-a7bf-ebe9a71e606f	15000	72a2b81e-8bf7-4ec3-8acc-707c4bc75abb	2025-07-12 05:52:39.653711+00	4ab6a96b-3fa9-4b86-80b8-b28f98508d00
636b718d-d5fc-4e6c-beb9-b6bf1572cb13	5000	70bcb628-f988-469d-9b8a-955780275ae4	2025-07-12 05:52:39.653711+00	ca9b4d87-89bd-4ff9-9da5-d4b2f81db5e8
636b718d-d5fc-4e6c-beb9-b6bf1572cb13	10000	4d126bd0-3cf0-41a6-b1bc-099a7aaf6de3	2025-07-12 05:52:39.653711+00	158250da-8379-4ed5-95c3-10e661ac4c16
636b718d-d5fc-4e6c-beb9-b6bf1572cb13	15000	dc284e45-1b3c-44c0-b910-60b22f7e0b63	2025-07-12 05:52:39.653711+00	4ab6a96b-3fa9-4b86-80b8-b28f98508d00
f18d148b-88ca-48d4-ab19-ae6398bb677e	6000	af063eac-7341-47c1-a895-c4401b463cb2	2025-07-12 06:03:31.332654+00	6530a546-9034-4b36-93c9-95ac1802cc83
f18d148b-88ca-48d4-ab19-ae6398bb677e	8000	4c6dd366-2331-4afb-8b07-09402b8132ae	2025-07-12 06:03:31.332654+00	f8f146c2-5dfc-48a4-977e-9021fab251d6
f18d148b-88ca-48d4-ab19-ae6398bb677e	12000	8d13b2b2-97e1-45d2-ac8d-4d66a4c7a598	2025-07-12 06:03:31.332654+00	f983a28b-7239-4935-a15e-aec4c7dfaf38
dd5f20e5-c3ba-4195-ab36-1af339117271	4000	a91dbf57-90ea-497b-83d2-fa1b5fa7bc08	2025-07-12 06:03:31.332654+00	6530a546-9034-4b36-93c9-95ac1802cc83
dd5f20e5-c3ba-4195-ab36-1af339117271	6000	e3597c1a-7a59-4aad-acc3-6e841017d147	2025-07-12 06:03:31.332654+00	f8f146c2-5dfc-48a4-977e-9021fab251d6
dd5f20e5-c3ba-4195-ab36-1af339117271	8000	101338e8-3a93-4e94-a523-6b86e87d209c	2025-07-12 06:03:31.332654+00	f983a28b-7239-4935-a15e-aec4c7dfaf38
5988cbdb-0653-4f17-b68c-d6f8332e4c8d	20000	80b6d9dd-e7bf-4357-9272-48f79268729c	2025-07-12 06:03:31.332654+00	6530a546-9034-4b36-93c9-95ac1802cc83
5988cbdb-0653-4f17-b68c-d6f8332e4c8d	25000	fed2440a-aef1-4e00-aee5-c8ff16b9a249	2025-07-12 06:03:31.332654+00	f8f146c2-5dfc-48a4-977e-9021fab251d6
5988cbdb-0653-4f17-b68c-d6f8332e4c8d	30000	a11a1cb1-9a07-4591-976a-8221fbbf05bf	2025-07-12 06:03:31.332654+00	f983a28b-7239-4935-a15e-aec4c7dfaf38
49f4fb06-01d3-406d-8ae0-159bb708dae3	30000	74a3b876-8829-4d91-ad48-340c5a9a07de	2025-07-12 06:03:31.332654+00	6530a546-9034-4b36-93c9-95ac1802cc83
49f4fb06-01d3-406d-8ae0-159bb708dae3	20000	7c820509-04aa-427a-8db1-d6fbac75d512	2025-07-12 06:03:31.332654+00	f8f146c2-5dfc-48a4-977e-9021fab251d6
49f4fb06-01d3-406d-8ae0-159bb708dae3	10000	4b1f482a-4111-41a5-b07b-ea67db4c25a6	2025-07-12 06:03:31.332654+00	f983a28b-7239-4935-a15e-aec4c7dfaf38
18862fc4-21e3-4e98-83a3-0b853da64821	5000	2c72d4ce-f484-446f-ac23-3adb54e91a8e	2025-07-12 06:03:31.332654+00	6530a546-9034-4b36-93c9-95ac1802cc83
18862fc4-21e3-4e98-83a3-0b853da64821	10000	3e25f445-5338-4521-9002-36e1fec9ba82	2025-07-12 06:03:31.332654+00	f8f146c2-5dfc-48a4-977e-9021fab251d6
18862fc4-21e3-4e98-83a3-0b853da64821	15000	61b2705e-2f6d-4d92-a08c-d35f266407f9	2025-07-12 06:03:31.332654+00	f983a28b-7239-4935-a15e-aec4c7dfaf38
5f9e5907-4abc-452b-95b9-5ff87739661c	5000	aac6bcbc-fdd6-48f6-98c4-5fd1d355d8b2	2025-07-12 06:03:31.332654+00	6530a546-9034-4b36-93c9-95ac1802cc83
5f9e5907-4abc-452b-95b9-5ff87739661c	10000	428d9a2f-188c-4866-8362-0ac17f461cf6	2025-07-12 06:03:31.332654+00	f8f146c2-5dfc-48a4-977e-9021fab251d6
5f9e5907-4abc-452b-95b9-5ff87739661c	15000	c8ca5c81-d096-4be6-a705-dcc7be4dd459	2025-07-12 06:03:31.332654+00	f983a28b-7239-4935-a15e-aec4c7dfaf38
8d93401f-557b-42c3-815d-f288a53a4efb	6000	84a11013-6252-4a52-a99c-062e00363988	2025-07-13 07:23:38.406043+00	3b798880-5548-40af-80b9-12382a77e6cd
8d93401f-557b-42c3-815d-f288a53a4efb	8000	04dfc8fd-bbd6-4eef-be73-ee83fa2c6fd9	2025-07-13 07:23:38.406043+00	70957997-7a11-4645-82c4-714b44e2c321
8d93401f-557b-42c3-815d-f288a53a4efb	12000	ac7374d3-4ff4-4619-98db-d0d6cfb90943	2025-07-13 07:23:38.406043+00	eff8b578-211e-4540-b148-3c33063239d4
c26eeeef-e2a9-4f91-a37b-6c0cff91fdd8	4000	8e9f63a2-0d9a-48cd-b9fa-56d29ec42ffb	2025-07-13 07:23:38.406043+00	3b798880-5548-40af-80b9-12382a77e6cd
c26eeeef-e2a9-4f91-a37b-6c0cff91fdd8	6000	89998e8f-a784-4e41-8f88-0554d659f85b	2025-07-13 07:23:38.406043+00	70957997-7a11-4645-82c4-714b44e2c321
c26eeeef-e2a9-4f91-a37b-6c0cff91fdd8	8000	e615c3f2-ee1f-4360-82ce-637c7473850e	2025-07-13 07:23:38.406043+00	eff8b578-211e-4540-b148-3c33063239d4
ed9cd473-3609-4692-a2b3-b96c6a5ff2e5	20000	2cc7263e-9cdd-4d3b-a740-33f821e9b011	2025-07-13 07:23:38.406043+00	3b798880-5548-40af-80b9-12382a77e6cd
ed9cd473-3609-4692-a2b3-b96c6a5ff2e5	25000	204a56ba-891c-4874-8b8c-c8cea70cfe00	2025-07-13 07:23:38.406043+00	70957997-7a11-4645-82c4-714b44e2c321
ed9cd473-3609-4692-a2b3-b96c6a5ff2e5	30000	d6d85703-a773-4c64-9791-b509ea367be2	2025-07-13 07:23:38.406043+00	eff8b578-211e-4540-b148-3c33063239d4
5159a91c-dece-4077-95e9-3ddfc21eaa22	30000	567a76df-5e89-4914-8d22-ce6797706834	2025-07-13 07:23:38.406043+00	3b798880-5548-40af-80b9-12382a77e6cd
5159a91c-dece-4077-95e9-3ddfc21eaa22	20000	e0832970-b797-4ab5-81d0-40e68126b5ce	2025-07-13 07:23:38.406043+00	70957997-7a11-4645-82c4-714b44e2c321
5159a91c-dece-4077-95e9-3ddfc21eaa22	10000	8f5d14bf-b441-4eab-9115-358d69629932	2025-07-13 07:23:38.406043+00	eff8b578-211e-4540-b148-3c33063239d4
5069bdd5-e72d-491f-8077-d49d51ff6a79	5000	c4d73401-ccf8-4f25-925b-14af36bbf128	2025-07-13 07:23:38.406043+00	3b798880-5548-40af-80b9-12382a77e6cd
5069bdd5-e72d-491f-8077-d49d51ff6a79	10000	40463f14-27ca-4fdd-92e0-a89f1b7c4a6a	2025-07-13 07:23:38.406043+00	70957997-7a11-4645-82c4-714b44e2c321
5069bdd5-e72d-491f-8077-d49d51ff6a79	15000	fdb3a4e5-9298-496e-a41b-4a14eb67dba1	2025-07-13 07:23:38.406043+00	eff8b578-211e-4540-b148-3c33063239d4
3a2337ca-7113-4ff1-ba8a-a702b7c5d986	5000	ad2f87dd-e059-453d-92f3-623514abeb5d	2025-07-13 07:23:38.406043+00	3b798880-5548-40af-80b9-12382a77e6cd
3a2337ca-7113-4ff1-ba8a-a702b7c5d986	10000	9c4c4eb3-f9f9-4ede-af17-b0c428dbc0d2	2025-07-13 07:23:38.406043+00	70957997-7a11-4645-82c4-714b44e2c321
3a2337ca-7113-4ff1-ba8a-a702b7c5d986	15000	bb5ffdd2-5ba5-43ff-a59b-6d3b89722be6	2025-07-13 07:23:38.406043+00	eff8b578-211e-4540-b148-3c33063239d4
7171dc14-31d7-43a1-b8bc-854f8a230523	6000	a58b8e8e-9538-42c7-805c-66ace9989829	2025-07-20 03:20:17.020718+00	f45b2650-669f-4d04-b8c6-81830d988284
7171dc14-31d7-43a1-b8bc-854f8a230523	8000	f91fce34-ff26-4255-acf1-3ebf1dbaafe3	2025-07-20 03:20:17.020718+00	abb53ff1-92dd-4079-ac2f-8205bca374be
7171dc14-31d7-43a1-b8bc-854f8a230523	12000	c6a05762-b470-4121-abda-e553271b2634	2025-07-20 03:20:17.020718+00	39f5045c-cc86-48b8-bcdd-4681eec42144
4ab071cd-16b7-4b9b-a8b7-52871fbddd4e	4000	455997b1-3365-4d9b-ab1c-c3810f50968f	2025-07-20 03:20:17.020718+00	f45b2650-669f-4d04-b8c6-81830d988284
4ab071cd-16b7-4b9b-a8b7-52871fbddd4e	6000	117031ff-c9f9-47d1-a44d-ef10a29f2684	2025-07-20 03:20:17.020718+00	abb53ff1-92dd-4079-ac2f-8205bca374be
4ab071cd-16b7-4b9b-a8b7-52871fbddd4e	8000	b2eec0f1-d26d-4f7e-9851-4f54e6bec686	2025-07-20 03:20:17.020718+00	39f5045c-cc86-48b8-bcdd-4681eec42144
3187c4e4-608d-4a5b-8fd8-758bbb9f6401	20000	9ba635e5-d590-4dc3-8df3-a7a4ade53754	2025-07-20 03:20:17.020718+00	f45b2650-669f-4d04-b8c6-81830d988284
3187c4e4-608d-4a5b-8fd8-758bbb9f6401	25000	6758a9a2-2ee8-424a-9b3c-00999e4d5705	2025-07-20 03:20:17.020718+00	abb53ff1-92dd-4079-ac2f-8205bca374be
3187c4e4-608d-4a5b-8fd8-758bbb9f6401	30000	faa3a93a-8a81-4d69-bad3-0b12433bb535	2025-07-20 03:20:17.020718+00	39f5045c-cc86-48b8-bcdd-4681eec42144
664f758c-ef78-45ef-9909-700f6dd39837	30000	ad7826b9-15f8-451b-81b9-0b30a2b824d3	2025-07-20 03:20:17.020718+00	f45b2650-669f-4d04-b8c6-81830d988284
664f758c-ef78-45ef-9909-700f6dd39837	20000	5d686ecb-78d0-49d8-b06e-11ef2638e725	2025-07-20 03:20:17.020718+00	abb53ff1-92dd-4079-ac2f-8205bca374be
664f758c-ef78-45ef-9909-700f6dd39837	10000	f74735b0-3618-4f41-8c2f-66018467de7a	2025-07-20 03:20:17.020718+00	39f5045c-cc86-48b8-bcdd-4681eec42144
513ab6c5-e84f-463f-ae29-56fb3643c2f4	5000	993fc308-6d20-4228-a9d2-bf597b8dae2b	2025-07-20 03:20:17.020718+00	f45b2650-669f-4d04-b8c6-81830d988284
513ab6c5-e84f-463f-ae29-56fb3643c2f4	10000	6f045ec7-42bd-45fc-afd8-f9a1faf81c1d	2025-07-20 03:20:17.020718+00	abb53ff1-92dd-4079-ac2f-8205bca374be
513ab6c5-e84f-463f-ae29-56fb3643c2f4	15000	737a0f44-f30f-4f57-853f-758693da3d7e	2025-07-20 03:20:17.020718+00	39f5045c-cc86-48b8-bcdd-4681eec42144
868a510c-67ff-4762-ad46-c871bf6d125c	5000	f3225905-8a22-471e-ac4c-2926cfad1df1	2025-07-20 03:20:17.020718+00	f45b2650-669f-4d04-b8c6-81830d988284
868a510c-67ff-4762-ad46-c871bf6d125c	10000	fbf70e3c-a387-42c2-9c12-39489591080e	2025-07-20 03:20:17.020718+00	abb53ff1-92dd-4079-ac2f-8205bca374be
868a510c-67ff-4762-ad46-c871bf6d125c	15000	fb4fd0b5-181b-450f-bbba-c7771370519b	2025-07-20 03:20:17.020718+00	39f5045c-cc86-48b8-bcdd-4681eec42144
44c3dc59-1a9e-4889-a6bf-a2b9e23e0c73	6000	386c96df-e18d-4994-a5c6-281140bce35f	2025-07-20 03:27:11.149442+00	00998bcc-3c17-4102-981b-0e18308bb006
44c3dc59-1a9e-4889-a6bf-a2b9e23e0c73	8000	fb2032f0-24ec-404a-8e25-898d3d66b80f	2025-07-20 03:27:11.149442+00	8460ed64-8915-4171-917d-d4e97d087dfb
44c3dc59-1a9e-4889-a6bf-a2b9e23e0c73	12000	c74051b4-ab4f-4bf8-8f12-f88015b24239	2025-07-20 03:27:11.149442+00	5a3314a6-356e-47a4-8ffe-18d50e4ec219
e41af5f6-32e8-412b-a8c0-6e2ff602e61b	4000	a6a73761-768b-4ead-b6da-71bece462f3a	2025-07-20 03:27:11.149442+00	00998bcc-3c17-4102-981b-0e18308bb006
e41af5f6-32e8-412b-a8c0-6e2ff602e61b	6000	39a3b289-8a8f-4a66-99c2-132125310505	2025-07-20 03:27:11.149442+00	8460ed64-8915-4171-917d-d4e97d087dfb
e41af5f6-32e8-412b-a8c0-6e2ff602e61b	8000	182e2216-44a5-4bfc-8457-8617fbabca2d	2025-07-20 03:27:11.149442+00	5a3314a6-356e-47a4-8ffe-18d50e4ec219
fc0a9f5e-ad8c-442e-b5f8-420cd4d49910	20000	0abfcd11-0571-4e94-8edb-d64cd7f76ee1	2025-07-20 03:27:11.149442+00	00998bcc-3c17-4102-981b-0e18308bb006
fc0a9f5e-ad8c-442e-b5f8-420cd4d49910	25000	49db73c2-f621-4256-9989-2b02e8960ff2	2025-07-20 03:27:11.149442+00	8460ed64-8915-4171-917d-d4e97d087dfb
fc0a9f5e-ad8c-442e-b5f8-420cd4d49910	30000	04a626ed-812b-47a4-b99e-0685832757dd	2025-07-20 03:27:11.149442+00	5a3314a6-356e-47a4-8ffe-18d50e4ec219
729e0b7c-e911-4575-8548-cb37dae3b318	30000	0af0f163-e6a9-4ab3-bd1d-33fa46fe1186	2025-07-20 03:27:11.149442+00	00998bcc-3c17-4102-981b-0e18308bb006
729e0b7c-e911-4575-8548-cb37dae3b318	20000	352f93ac-a4de-4485-99da-702537522620	2025-07-20 03:27:11.149442+00	8460ed64-8915-4171-917d-d4e97d087dfb
729e0b7c-e911-4575-8548-cb37dae3b318	10000	dc11026a-054a-4c7b-944f-ac3ee56a2533	2025-07-20 03:27:11.149442+00	5a3314a6-356e-47a4-8ffe-18d50e4ec219
c603c6d5-68eb-4dbf-b74b-70b7ee5d77c2	5000	c1e39a27-343b-4626-b92e-981551847f1b	2025-07-20 03:27:11.149442+00	00998bcc-3c17-4102-981b-0e18308bb006
c603c6d5-68eb-4dbf-b74b-70b7ee5d77c2	10000	e4796ecd-b2e0-4363-8c4d-03f5a8b49ef0	2025-07-20 03:27:11.149442+00	8460ed64-8915-4171-917d-d4e97d087dfb
c603c6d5-68eb-4dbf-b74b-70b7ee5d77c2	15000	24841ef2-523f-476f-9804-b0dfc7138f99	2025-07-20 03:27:11.149442+00	5a3314a6-356e-47a4-8ffe-18d50e4ec219
f0cc027a-17a8-48a0-9235-7ae4daf0d37b	5000	4917e3ed-5416-42b9-ba14-12eeff9a6caf	2025-07-20 03:27:11.149442+00	00998bcc-3c17-4102-981b-0e18308bb006
f0cc027a-17a8-48a0-9235-7ae4daf0d37b	10000	3333786b-667d-4c54-8152-b330ff9abb7a	2025-07-20 03:27:11.149442+00	8460ed64-8915-4171-917d-d4e97d087dfb
f0cc027a-17a8-48a0-9235-7ae4daf0d37b	15000	67d384a6-01a7-4682-bb26-b2fe89762012	2025-07-20 03:27:11.149442+00	5a3314a6-356e-47a4-8ffe-18d50e4ec219
f1e65129-aed7-4138-8a82-d3e5024be7ca	6000	40840991-6234-47d3-ac01-82fdba61e051	2025-08-05 14:27:20.893026+00	9c600ebe-2492-46dd-85c4-4842111ce368
f1e65129-aed7-4138-8a82-d3e5024be7ca	8000	d76820d6-ee05-4f38-82af-d91c371ef107	2025-08-05 14:27:20.893026+00	6e2a55ef-2bf7-4bed-a467-15e06b303784
f1e65129-aed7-4138-8a82-d3e5024be7ca	12000	27e59339-7e78-4cf5-a22f-4406628393b6	2025-08-05 14:27:20.893026+00	991418de-6b30-42e5-a925-3d1c8b780d91
5e8ca89d-1c8f-45cf-89bd-2f0335719241	4000	5741dc28-0a22-4f4a-94c1-7e800e85ee08	2025-08-05 14:27:20.893026+00	9c600ebe-2492-46dd-85c4-4842111ce368
5e8ca89d-1c8f-45cf-89bd-2f0335719241	6000	d9f38ec7-1824-4ff6-8407-70b0780d31fe	2025-08-05 14:27:20.893026+00	6e2a55ef-2bf7-4bed-a467-15e06b303784
5e8ca89d-1c8f-45cf-89bd-2f0335719241	8000	5f6dc780-5649-4523-9c6c-5f490297d892	2025-08-05 14:27:20.893026+00	991418de-6b30-42e5-a925-3d1c8b780d91
1eb79a3a-a6b1-4f6b-aec2-33a11517d7bb	20000	43357b2f-3fc1-4491-a02c-d289a061723a	2025-08-05 14:27:20.893026+00	9c600ebe-2492-46dd-85c4-4842111ce368
1eb79a3a-a6b1-4f6b-aec2-33a11517d7bb	25000	6f9a0811-1a7f-4270-b98b-092b6c458957	2025-08-05 14:27:20.893026+00	6e2a55ef-2bf7-4bed-a467-15e06b303784
1eb79a3a-a6b1-4f6b-aec2-33a11517d7bb	30000	8ba31960-3d84-4ace-84e3-d038d0e02c27	2025-08-05 14:27:20.893026+00	991418de-6b30-42e5-a925-3d1c8b780d91
d59c4fd7-b65b-41ff-9796-b74a79eb3b89	30000	a26fe9bc-6bc2-46ea-8d51-7e8981bff47e	2025-08-05 14:27:20.893026+00	9c600ebe-2492-46dd-85c4-4842111ce368
d59c4fd7-b65b-41ff-9796-b74a79eb3b89	20000	8e0c4e22-c9ed-47ff-b96c-d89556af20be	2025-08-05 14:27:20.893026+00	6e2a55ef-2bf7-4bed-a467-15e06b303784
d59c4fd7-b65b-41ff-9796-b74a79eb3b89	10000	b9a20e8c-b167-41a6-b994-0d71fb9d4d0d	2025-08-05 14:27:20.893026+00	991418de-6b30-42e5-a925-3d1c8b780d91
c5f8dec4-f68b-4a54-bcaf-42029ff74bdf	5000	51e13865-cc21-457c-bd16-3a38bc2d8102	2025-08-05 14:27:20.893026+00	9c600ebe-2492-46dd-85c4-4842111ce368
c5f8dec4-f68b-4a54-bcaf-42029ff74bdf	10000	2b1cd59c-dea6-489e-9c14-10f3256a7eb1	2025-08-05 14:27:20.893026+00	6e2a55ef-2bf7-4bed-a467-15e06b303784
c5f8dec4-f68b-4a54-bcaf-42029ff74bdf	15000	152f2c62-9bda-4e36-927e-2aad6d22b040	2025-08-05 14:27:20.893026+00	991418de-6b30-42e5-a925-3d1c8b780d91
0c333200-7b95-488e-bbf3-c2de8be99d4a	5000	ca55d9e5-255b-4dbb-9597-9ec07e0be7ee	2025-08-05 14:27:20.893026+00	9c600ebe-2492-46dd-85c4-4842111ce368
0c333200-7b95-488e-bbf3-c2de8be99d4a	10000	4d24b7c1-1d7d-4bad-96f3-b932ab2bb955	2025-08-05 14:27:20.893026+00	6e2a55ef-2bf7-4bed-a467-15e06b303784
0c333200-7b95-488e-bbf3-c2de8be99d4a	15000	ef885be0-32ed-49bb-9fed-e1a1a962ef14	2025-08-05 14:27:20.893026+00	991418de-6b30-42e5-a925-3d1c8b780d91
d34e80d8-b9c2-4d37-8062-1ca691fdf0fa	6000	1e0dc2c1-0f37-438f-a739-760530d4e821	2025-08-12 13:48:13.33748+00	a8b8dc72-4c30-478b-b827-e500a95db888
d34e80d8-b9c2-4d37-8062-1ca691fdf0fa	8000	8661fc70-6335-4f11-ab1c-7df666de58f2	2025-08-12 13:48:13.33748+00	bf6ad88d-d3ff-4512-96d2-2d7172705476
d34e80d8-b9c2-4d37-8062-1ca691fdf0fa	12000	05eac36a-99cb-4264-99ae-9b7cc46cd591	2025-08-12 13:48:13.33748+00	030422b5-cf6d-4a40-b80f-28c12f8c8293
03ff0039-f996-4e4d-823b-d7119b207112	4000	966c3f12-0512-4648-aa28-8fa6facce52f	2025-08-12 13:48:13.33748+00	a8b8dc72-4c30-478b-b827-e500a95db888
03ff0039-f996-4e4d-823b-d7119b207112	6000	fe66dba1-640e-4ca3-b6e1-e3b3496d19ed	2025-08-12 13:48:13.33748+00	bf6ad88d-d3ff-4512-96d2-2d7172705476
03ff0039-f996-4e4d-823b-d7119b207112	8000	9b65bfc1-b201-46e6-8a11-b9a3e95a4bf0	2025-08-12 13:48:13.33748+00	030422b5-cf6d-4a40-b80f-28c12f8c8293
ab751b68-fa70-4a53-8fa3-20e7207197f4	20000	78d8c4ec-b9f5-4f15-9d93-6e3456c0a7a9	2025-08-12 13:48:13.33748+00	a8b8dc72-4c30-478b-b827-e500a95db888
ab751b68-fa70-4a53-8fa3-20e7207197f4	25000	ac1c663a-d97e-42f0-83c6-902e1321f93b	2025-08-12 13:48:13.33748+00	bf6ad88d-d3ff-4512-96d2-2d7172705476
ab751b68-fa70-4a53-8fa3-20e7207197f4	30000	3e976223-66b6-437d-b011-2efc1129e3ae	2025-08-12 13:48:13.33748+00	030422b5-cf6d-4a40-b80f-28c12f8c8293
59990330-110a-4196-86ca-35809748d639	30000	0600ac2b-bc10-45e5-9c25-d674c3ea36b8	2025-08-12 13:48:13.33748+00	a8b8dc72-4c30-478b-b827-e500a95db888
59990330-110a-4196-86ca-35809748d639	20000	90d2274e-8f2f-4a8c-8ecc-f4a9f9d6499c	2025-08-12 13:48:13.33748+00	bf6ad88d-d3ff-4512-96d2-2d7172705476
59990330-110a-4196-86ca-35809748d639	10000	b55f4cb6-a5b6-4e79-86de-ff7341c93c49	2025-08-12 13:48:13.33748+00	030422b5-cf6d-4a40-b80f-28c12f8c8293
f6c33e9f-763c-4372-acc5-5b5fc72897ba	5000	18ef0e55-aa36-4bb0-aca3-0a33385fbca9	2025-08-12 13:48:13.33748+00	a8b8dc72-4c30-478b-b827-e500a95db888
f6c33e9f-763c-4372-acc5-5b5fc72897ba	10000	608358d7-5543-48f3-9ec4-4c8ff7124dec	2025-08-12 13:48:13.33748+00	bf6ad88d-d3ff-4512-96d2-2d7172705476
f6c33e9f-763c-4372-acc5-5b5fc72897ba	15000	b19142bd-9bef-47f8-922b-04cbb6e70dd3	2025-08-12 13:48:13.33748+00	030422b5-cf6d-4a40-b80f-28c12f8c8293
b502a20e-1f73-4c29-8d1d-5ad947a0627e	5000	64ec7f76-7650-4bbd-9762-22a89bc526c2	2025-08-12 13:48:13.33748+00	a8b8dc72-4c30-478b-b827-e500a95db888
b502a20e-1f73-4c29-8d1d-5ad947a0627e	10000	1857e3de-6fdf-4aa4-87df-c6da812d95e7	2025-08-12 13:48:13.33748+00	bf6ad88d-d3ff-4512-96d2-2d7172705476
b502a20e-1f73-4c29-8d1d-5ad947a0627e	15000	423e04a0-d8db-4657-a884-932529da62e5	2025-08-12 13:48:13.33748+00	030422b5-cf6d-4a40-b80f-28c12f8c8293
2520b782-8dae-4ab6-b21a-41b53b881dd1	6000	65dfe383-b62c-4923-a999-2ac22d2f8a35	2025-08-26 13:33:51.993261+00	0ddbfd98-2b84-4b3c-87f5-60a0273c4c8e
2520b782-8dae-4ab6-b21a-41b53b881dd1	8000	e505ffa3-c705-4625-b5ce-f6a4ad064a3e	2025-08-26 13:33:51.993261+00	6292d8a9-af15-46be-837f-f9bd7840e0cf
2520b782-8dae-4ab6-b21a-41b53b881dd1	12000	fc22083b-fa58-44e4-b887-70dce291aa38	2025-08-26 13:33:51.993261+00	5866513f-d9b3-400b-989c-00b0e1eb3b75
48d06cec-d463-42b1-a0b0-73acb75b80ed	4000	f16ab725-8363-4637-80d5-e36942e5b589	2025-08-26 13:33:51.993261+00	0ddbfd98-2b84-4b3c-87f5-60a0273c4c8e
48d06cec-d463-42b1-a0b0-73acb75b80ed	6000	a713b90b-eb50-4c63-9c74-6de67687c135	2025-08-26 13:33:51.993261+00	6292d8a9-af15-46be-837f-f9bd7840e0cf
48d06cec-d463-42b1-a0b0-73acb75b80ed	8000	425173bf-7be3-40c0-8cb7-2c98647ff4e3	2025-08-26 13:33:51.993261+00	5866513f-d9b3-400b-989c-00b0e1eb3b75
736b116e-217e-4b6a-9af5-2a9b5df90ff6	4000	adef2eb8-2b46-4306-b4ee-ebe7108d90b6	2025-12-24 12:15:35.563358+00	96d809da-8a60-494e-a923-0f851dc095ec
736b116e-217e-4b6a-9af5-2a9b5df90ff6	6000	f6ec4cd8-85f9-483a-994f-bd256624df76	2025-12-24 12:15:35.563358+00	bca9722f-c8d2-43ad-b8bb-c34f57cff0da
736b116e-217e-4b6a-9af5-2a9b5df90ff6	8000	1afa030a-b73e-4441-b787-27b5867e895b	2025-12-24 12:15:35.563358+00	0a933314-040b-4b51-bd6f-ee8f0e9a2167
42230aeb-f872-47cb-b1a8-ca4778a13556	20000	76dd3d71-1ab3-4271-8884-0d627655fcab	2025-12-24 12:15:35.563358+00	96d809da-8a60-494e-a923-0f851dc095ec
42230aeb-f872-47cb-b1a8-ca4778a13556	25000	4fdf2c0a-5410-4db0-b7f3-a7c67fb08523	2025-12-24 12:15:35.563358+00	bca9722f-c8d2-43ad-b8bb-c34f57cff0da
42230aeb-f872-47cb-b1a8-ca4778a13556	30000	b43c08cc-78a4-49ec-af6a-b708e1db10f1	2025-12-24 12:15:35.563358+00	0a933314-040b-4b51-bd6f-ee8f0e9a2167
b16ccfac-2b09-45f0-85c5-fdd1a8b67b4e	30000	eb3ec453-a1ae-415d-b17b-9d1b4fc3192e	2025-12-24 12:15:35.563358+00	96d809da-8a60-494e-a923-0f851dc095ec
b16ccfac-2b09-45f0-85c5-fdd1a8b67b4e	20000	dbf81171-89b4-46eb-b712-41d275698e82	2025-12-24 12:15:35.563358+00	bca9722f-c8d2-43ad-b8bb-c34f57cff0da
b16ccfac-2b09-45f0-85c5-fdd1a8b67b4e	10000	d394a74c-6ee9-4a6d-91a1-8e5f4798b32a	2025-12-24 12:15:35.563358+00	0a933314-040b-4b51-bd6f-ee8f0e9a2167
68228ad3-8ea1-45f8-8a53-cc12c3fb2b85	5000	c35ab79f-4693-4d47-8077-86d041a87eed	2025-12-24 12:15:35.563358+00	96d809da-8a60-494e-a923-0f851dc095ec
68228ad3-8ea1-45f8-8a53-cc12c3fb2b85	10000	72472a50-9398-457d-b563-819670f38310	2025-12-24 12:15:35.563358+00	bca9722f-c8d2-43ad-b8bb-c34f57cff0da
68228ad3-8ea1-45f8-8a53-cc12c3fb2b85	15000	4acf7231-b189-4729-9614-9fa5cb05690e	2025-12-24 12:15:35.563358+00	0a933314-040b-4b51-bd6f-ee8f0e9a2167
2253837f-605a-4b8d-97ed-f16f6018a874	5000	cb4a491c-feb1-4f56-bba5-a5a00d001ecc	2025-09-09 15:02:17.017864+00	bb8d886d-f770-4eb7-82fa-dcd254d39e8a
2253837f-605a-4b8d-97ed-f16f6018a874	10000	cc266e6c-9ef3-4cef-9584-8d3759172b97	2025-09-09 15:02:17.017864+00	5fae84c4-610b-42a0-9e31-a6eb2ff9e951
2253837f-605a-4b8d-97ed-f16f6018a874	15000	4d450ef0-e0d1-4851-8938-f428158d02ee	2025-09-09 15:02:17.017864+00	40f05a5f-f197-4de4-831e-96b4a6126eec
bf83182b-2802-478a-bd5b-12cda1ef888d	5000	5bd3fc49-9f75-4937-8f28-4bd9668ab767	2025-09-09 15:02:17.017864+00	bb8d886d-f770-4eb7-82fa-dcd254d39e8a
bf83182b-2802-478a-bd5b-12cda1ef888d	10000	614ee7ba-53f5-46bc-9382-fc78d8ef5615	2025-09-09 15:02:17.017864+00	5fae84c4-610b-42a0-9e31-a6eb2ff9e951
bf83182b-2802-478a-bd5b-12cda1ef888d	15000	c16a97d3-171b-4586-810c-352de39b997f	2025-09-09 15:02:17.017864+00	40f05a5f-f197-4de4-831e-96b4a6126eec
4cf89487-df3a-46e9-a239-ceb2d13b2408	6000	cbf5772c-61e3-4175-8884-839e774084b1	2025-09-09 15:11:14.421709+00	bb8d886d-f770-4eb7-82fa-dcd254d39e8a
4cf89487-df3a-46e9-a239-ceb2d13b2408	8000	5b793c99-4a61-4b55-bd88-8ff7f4e4230c	2025-09-09 15:11:14.645743+00	5fae84c4-610b-42a0-9e31-a6eb2ff9e951
4cf89487-df3a-46e9-a239-ceb2d13b2408	12000	5341a723-5550-49c5-a278-c8d0815a86fc	2025-09-09 15:11:14.867684+00	40f05a5f-f197-4de4-831e-96b4a6126eec
3b9f30ac-64d8-4941-aff6-79cec285fa06	2005	92f914d2-ab69-4d67-9153-c9637722b426	2025-09-12 13:21:07.225265+00	5fae84c4-610b-42a0-9e31-a6eb2ff9e951
1c09d04f-3b07-40b3-9ef1-af3546b692e2	25000	f5010b9a-6626-4e2e-8e60-08070f01e6d5	2025-09-12 13:23:48.821299+00	5fae84c4-610b-42a0-9e31-a6eb2ff9e951
da33acb6-03be-4ae1-aede-8ff5f4309e95	6000	f1b02a1c-d1e7-404f-a771-ab7affb7d155	2025-09-23 00:42:12.596764+00	abf8147b-eeed-479b-bb20-2bb07dbc6a17
da33acb6-03be-4ae1-aede-8ff5f4309e95	8000	13b08b87-18cf-48a0-beb5-06aab345aba2	2025-09-23 00:42:12.596764+00	19e1c045-6bc6-49f6-b8e8-4b43f5b33fa5
da33acb6-03be-4ae1-aede-8ff5f4309e95	12000	9da3000e-9fb7-4839-93d6-0d948b921e3e	2025-09-23 00:42:12.596764+00	b271cdb1-db86-4bec-88ee-aa7c3a1695d1
3e1c5c35-b7fc-49ae-ac4a-c5c9098a915f	4000	e31a483c-94f6-4805-ada0-6b7ec897bde8	2025-09-23 00:42:12.596764+00	abf8147b-eeed-479b-bb20-2bb07dbc6a17
3e1c5c35-b7fc-49ae-ac4a-c5c9098a915f	6000	7e0c4e3d-2dee-4598-bf0f-6331a8617d8e	2025-09-23 00:42:12.596764+00	19e1c045-6bc6-49f6-b8e8-4b43f5b33fa5
3e1c5c35-b7fc-49ae-ac4a-c5c9098a915f	8000	2c6001d0-620b-4ecc-a2a0-b4ecf2a8b0a2	2025-09-23 00:42:12.596764+00	b271cdb1-db86-4bec-88ee-aa7c3a1695d1
3d39897b-c053-429a-918c-6d222191b514	20000	196afb0b-b240-469a-b3ed-ddcf06ff601a	2025-09-23 00:42:12.596764+00	abf8147b-eeed-479b-bb20-2bb07dbc6a17
3d39897b-c053-429a-918c-6d222191b514	25000	75f9559c-87d1-4c0c-87fa-6837f05f27e1	2025-09-23 00:42:12.596764+00	19e1c045-6bc6-49f6-b8e8-4b43f5b33fa5
3d39897b-c053-429a-918c-6d222191b514	30000	491a6800-abef-4100-b6f5-56c33ee7519d	2025-09-23 00:42:12.596764+00	b271cdb1-db86-4bec-88ee-aa7c3a1695d1
de535e44-abc0-4b0b-8384-4e7289c5c090	30000	9ad1aad3-8c61-466b-810b-27a3dc5a9cfe	2025-09-23 00:42:12.596764+00	abf8147b-eeed-479b-bb20-2bb07dbc6a17
de535e44-abc0-4b0b-8384-4e7289c5c090	20000	ef8af75e-26bc-452b-941e-cefe220596c2	2025-09-23 00:42:12.596764+00	19e1c045-6bc6-49f6-b8e8-4b43f5b33fa5
de535e44-abc0-4b0b-8384-4e7289c5c090	10000	e740bd7e-baf6-4d6a-ac0e-c5b5257f48b3	2025-09-23 00:42:12.596764+00	b271cdb1-db86-4bec-88ee-aa7c3a1695d1
28e78b06-273a-4cb9-8cd2-1b69f7ef7633	5000	aaf273e9-18d1-4c02-9172-77efea54e544	2025-09-23 00:42:12.596764+00	abf8147b-eeed-479b-bb20-2bb07dbc6a17
28e78b06-273a-4cb9-8cd2-1b69f7ef7633	10000	782a052b-30bb-479e-81ee-11996d5449b1	2025-09-23 00:42:12.596764+00	19e1c045-6bc6-49f6-b8e8-4b43f5b33fa5
28e78b06-273a-4cb9-8cd2-1b69f7ef7633	15000	c121716d-f9b7-48a9-88d3-7f8b984e155a	2025-09-23 00:42:12.596764+00	b271cdb1-db86-4bec-88ee-aa7c3a1695d1
82fd5297-f241-475d-b5ca-e394ec135b20	5000	05984ca1-273f-4179-b936-1a9c5b117f73	2025-09-23 00:42:12.596764+00	abf8147b-eeed-479b-bb20-2bb07dbc6a17
82fd5297-f241-475d-b5ca-e394ec135b20	10000	87defe3b-c8c0-4b3a-bc7e-86db59671e52	2025-09-23 00:42:12.596764+00	19e1c045-6bc6-49f6-b8e8-4b43f5b33fa5
82fd5297-f241-475d-b5ca-e394ec135b20	15000	c0f8ca9b-7358-4a08-800d-795624632bdc	2025-09-23 00:42:12.596764+00	b271cdb1-db86-4bec-88ee-aa7c3a1695d1
b203a6ce-beaa-49cf-81ef-ee462b6798f4	5000	88045d6b-22c5-49d7-b37c-671aa4b89d17	2025-12-24 12:15:35.563358+00	96d809da-8a60-494e-a923-0f851dc095ec
b203a6ce-beaa-49cf-81ef-ee462b6798f4	10000	7c88e1a1-f653-4c24-b5fe-fc16d159f988	2025-12-24 12:15:35.563358+00	bca9722f-c8d2-43ad-b8bb-c34f57cff0da
b203a6ce-beaa-49cf-81ef-ee462b6798f4	15000	b66090cb-e025-4033-8837-dd03fbdbaa1d	2025-12-24 12:15:35.563358+00	0a933314-040b-4b51-bd6f-ee8f0e9a2167
6881c6eb-7f7b-4bce-91cc-f94036d5e8a5	25000	6dae84af-2a02-4d08-a0d9-f4fad9776247	2025-12-26 12:10:31.839531+00	1a410093-18cc-46f7-9c14-28c356ac75c3
6881c6eb-7f7b-4bce-91cc-f94036d5e8a5	1200	18e8eb5b-82ca-48bf-994d-9d3aef2a89bb	2025-12-26 12:10:32.065756+00	329b1676-cc02-406f-b4e4-6cf5770f1099
2376346c-b674-4910-8415-69bba60dd821	15000	305ea024-ddee-4d8b-b017-86f1c17c0bbb	2025-12-29 14:01:00.127012+00	2a098950-d5a1-499a-8cc6-4f36e6bda64c
424893ff-b48a-4a3b-a0ff-cb67e5241a89	5000	f9f073f7-d542-46fb-b891-e811e2137e9d	2025-12-29 14:01:00.127012+00	79798fa5-eca2-4925-bb82-6be3e500fc56
424893ff-b48a-4a3b-a0ff-cb67e5241a89	10000	a9c7c9b8-c2af-494e-92e4-c0e62a7545c6	2025-12-29 14:01:00.127012+00	7e6846dd-78c8-4c65-bbe9-0df70e15e316
424893ff-b48a-4a3b-a0ff-cb67e5241a89	15000	f18c4c76-7849-4695-9dd2-a850da4670dc	2025-12-29 14:01:00.127012+00	2a098950-d5a1-499a-8cc6-4f36e6bda64c
34efee85-0e62-4bee-bbc1-3257cadf4c49	30000	912a72bb-faa0-4c76-b783-6c2db7ba45f6	2025-09-23 12:04:44.747711+00	1a410093-18cc-46f7-9c14-28c356ac75c3
34efee85-0e62-4bee-bbc1-3257cadf4c49	20000	4e28150f-fbc3-47e8-b7ec-4e3612317e68	2025-09-23 12:04:44.747711+00	f9e92872-603a-4a2f-a0c2-617ab0472d4b
34efee85-0e62-4bee-bbc1-3257cadf4c49	10000	58a25954-f44b-4bdf-bad3-ed1020751a60	2025-09-23 12:04:44.747711+00	26dbce97-4e72-4e4c-83a2-2b06c6834dc0
4557bb24-b8cc-4558-b502-00a4ebfa8e6a	6000	a34d4b92-b927-4453-b340-1e16612f4b1f	2025-12-29 14:02:53.837645+00	587712b4-77d7-4c30-988a-723a5b7695dd
4557bb24-b8cc-4558-b502-00a4ebfa8e6a	8000	55ec5184-1669-48ec-af88-6684dd8abc76	2025-12-29 14:02:53.837645+00	c88faf7d-86fa-4965-b72c-4e2362726cd0
4557bb24-b8cc-4558-b502-00a4ebfa8e6a	12000	5f1ad01a-68c6-4cd7-9e5c-439d732b7bcb	2025-12-29 14:02:53.837645+00	b35f4309-d4c3-4e75-ac46-cd12a807f08a
f53e3edd-c4aa-433c-a122-af1ac430ccaf	20000	8a6b7667-2f25-4aaa-8760-1078a69116f7	2025-10-24 12:44:57.236295+00	1a410093-18cc-46f7-9c14-28c356ac75c3
f53e3edd-c4aa-433c-a122-af1ac430ccaf	100003	3b28c4b1-6d3f-4d85-a879-32c8940b7e02	2025-10-24 12:44:57.464372+00	f9e92872-603a-4a2f-a0c2-617ab0472d4b
f53e3edd-c4aa-433c-a122-af1ac430ccaf	15000	e398ee35-2bf8-42bd-8f87-3409c1a18fba	2025-10-24 12:44:57.687059+00	26dbce97-4e72-4e4c-83a2-2b06c6834dc0
76e0950f-1dd1-4fd3-a2de-230993cf3c23	6000	1bf17361-541b-4b62-95c4-756ebb40f712	2025-11-10 12:03:00.974657+00	8509068c-dbdc-477a-8459-9c5656971747
76e0950f-1dd1-4fd3-a2de-230993cf3c23	8000	afec6609-7d97-4bf2-b1a9-ced3035aa3cf	2025-11-10 12:03:00.974657+00	810c228e-d9ce-43db-98bf-d7d521a5f5ba
76e0950f-1dd1-4fd3-a2de-230993cf3c23	12000	6c194e51-3e08-4fcc-b191-d8adeef03cbf	2025-11-10 12:03:00.974657+00	c43ae7c1-3432-47de-9f17-a1ae54d0bdbd
d9ffb40c-fa90-4f90-a01a-2fcbaa9751de	4000	984796b7-a875-4aa6-99a7-f5116e19c0aa	2025-11-10 12:03:00.974657+00	8509068c-dbdc-477a-8459-9c5656971747
d9ffb40c-fa90-4f90-a01a-2fcbaa9751de	6000	6a7df626-6e86-4e4e-8eca-e55b60d4744d	2025-11-10 12:03:00.974657+00	810c228e-d9ce-43db-98bf-d7d521a5f5ba
d9ffb40c-fa90-4f90-a01a-2fcbaa9751de	8000	46755b49-b619-4813-8856-09204aa48bb3	2025-11-10 12:03:00.974657+00	c43ae7c1-3432-47de-9f17-a1ae54d0bdbd
aa07aa06-7c52-46d6-93e6-507682d16ad3	20000	7aa79b62-e966-42a8-9603-3a8bfaab8992	2025-11-10 12:03:00.974657+00	8509068c-dbdc-477a-8459-9c5656971747
aa07aa06-7c52-46d6-93e6-507682d16ad3	25000	2bcda195-11a4-45eb-ab6e-57fc34a65f77	2025-11-10 12:03:00.974657+00	810c228e-d9ce-43db-98bf-d7d521a5f5ba
aa07aa06-7c52-46d6-93e6-507682d16ad3	30000	ea0d0999-25fa-48b6-a4cd-553becdf83be	2025-11-10 12:03:00.974657+00	c43ae7c1-3432-47de-9f17-a1ae54d0bdbd
2f2da3ca-d98d-44bc-98e1-2f9258722ef3	30000	b169b20c-9fad-481e-9ab9-21977454127f	2025-11-10 12:03:00.974657+00	8509068c-dbdc-477a-8459-9c5656971747
2f2da3ca-d98d-44bc-98e1-2f9258722ef3	20000	0bb30794-4980-4c9e-b0d6-28087cfb6a38	2025-11-10 12:03:00.974657+00	810c228e-d9ce-43db-98bf-d7d521a5f5ba
2f2da3ca-d98d-44bc-98e1-2f9258722ef3	10000	7536441c-b959-4619-b639-b6dd8c65bad0	2025-11-10 12:03:00.974657+00	c43ae7c1-3432-47de-9f17-a1ae54d0bdbd
a4e8d788-d5ea-4ddf-8695-8060d0e2d31a	5000	eb7058de-ed5d-4eb4-9459-c3b59a1c2c23	2025-11-10 12:03:00.974657+00	8509068c-dbdc-477a-8459-9c5656971747
a4e8d788-d5ea-4ddf-8695-8060d0e2d31a	10000	2c474e9c-95d2-4877-90c0-add96df4329a	2025-11-10 12:03:00.974657+00	810c228e-d9ce-43db-98bf-d7d521a5f5ba
a4e8d788-d5ea-4ddf-8695-8060d0e2d31a	15000	1b65d830-9369-4cfa-9e1f-911c0acbc591	2025-11-10 12:03:00.974657+00	c43ae7c1-3432-47de-9f17-a1ae54d0bdbd
e4928f6f-7a14-4446-a2eb-cf5322e8d554	5000	5d5ccdc4-a80f-4460-8dd4-36f710d59245	2025-11-10 12:03:00.974657+00	8509068c-dbdc-477a-8459-9c5656971747
e4928f6f-7a14-4446-a2eb-cf5322e8d554	10000	7cc83d79-4595-42fe-8199-acfa22847ef5	2025-11-10 12:03:00.974657+00	810c228e-d9ce-43db-98bf-d7d521a5f5ba
e4928f6f-7a14-4446-a2eb-cf5322e8d554	15000	0c17bc54-996a-491c-a09a-e5da2b18e318	2025-11-10 12:03:00.974657+00	c43ae7c1-3432-47de-9f17-a1ae54d0bdbd
327bb7d7-12d5-425b-a22f-d64a1e5265c1	6000	c54b2bd7-91f0-48c1-a879-c249bca313b4	2025-11-10 12:08:21.837634+00	049f7adf-d1fa-465f-bf3e-8fef5a519ff4
327bb7d7-12d5-425b-a22f-d64a1e5265c1	8000	7aca5d19-5a56-454d-be5c-7cd5872d8981	2025-11-10 12:08:21.837634+00	d4de3459-36f0-40ee-834a-3f709006c12c
327bb7d7-12d5-425b-a22f-d64a1e5265c1	12000	5a064025-5f2d-4e17-8802-794f56600aeb	2025-11-10 12:08:21.837634+00	b25a9aee-f026-42d2-98bd-ff4ad1997200
63d38926-3f13-48d8-a1a8-493e1c455dbd	4000	af07e8c7-a88a-4f92-98c5-3a3a94bbfc19	2025-11-10 12:08:21.837634+00	049f7adf-d1fa-465f-bf3e-8fef5a519ff4
63d38926-3f13-48d8-a1a8-493e1c455dbd	6000	2b9980f2-8aed-4af9-8b9d-504afee071b0	2025-11-10 12:08:21.837634+00	d4de3459-36f0-40ee-834a-3f709006c12c
63d38926-3f13-48d8-a1a8-493e1c455dbd	8000	4efe43c9-841c-41fd-a7e2-dd3bc39a44b1	2025-11-10 12:08:21.837634+00	b25a9aee-f026-42d2-98bd-ff4ad1997200
a9b1cc8a-8b93-4c5c-aa03-d7b8cb0c3bdc	20000	5e99a0ea-2938-4284-8c28-f34575b9552d	2025-11-10 12:08:21.837634+00	049f7adf-d1fa-465f-bf3e-8fef5a519ff4
a9b1cc8a-8b93-4c5c-aa03-d7b8cb0c3bdc	25000	649a2e71-6cc8-462e-a5f5-0fc1f83975ff	2025-11-10 12:08:21.837634+00	d4de3459-36f0-40ee-834a-3f709006c12c
a9b1cc8a-8b93-4c5c-aa03-d7b8cb0c3bdc	30000	27cf286c-e0d1-46db-b4cd-4cbcf62f03ad	2025-11-10 12:08:21.837634+00	b25a9aee-f026-42d2-98bd-ff4ad1997200
65cfeee7-ea87-48b0-9447-e5f0ae046fc0	30000	dd947332-9ebf-4f2e-be4f-bb928cea3e14	2025-11-10 12:08:21.837634+00	049f7adf-d1fa-465f-bf3e-8fef5a519ff4
65cfeee7-ea87-48b0-9447-e5f0ae046fc0	20000	d478d3ff-80e7-4697-a00b-e2b11147a447	2025-11-10 12:08:21.837634+00	d4de3459-36f0-40ee-834a-3f709006c12c
65cfeee7-ea87-48b0-9447-e5f0ae046fc0	10000	c9534f38-3ce4-4278-be8d-841b70652e36	2025-11-10 12:08:21.837634+00	b25a9aee-f026-42d2-98bd-ff4ad1997200
2f695346-932c-4ef2-816e-e1b3b1e99b7a	5000	1cd25e35-708e-43d9-b8e7-51ee8d56d619	2025-11-10 12:08:21.837634+00	049f7adf-d1fa-465f-bf3e-8fef5a519ff4
2f695346-932c-4ef2-816e-e1b3b1e99b7a	10000	7d9ed59c-05f2-4382-9eb3-527a324a828a	2025-11-10 12:08:21.837634+00	d4de3459-36f0-40ee-834a-3f709006c12c
2f695346-932c-4ef2-816e-e1b3b1e99b7a	15000	a2517867-87c6-4396-964a-3bcfabc689d2	2025-11-10 12:08:21.837634+00	b25a9aee-f026-42d2-98bd-ff4ad1997200
f2407bed-c06e-4e4d-b5e7-bafa7943d188	5000	d09ce8cc-4e6f-41e6-9717-1ddb7cb1b9dc	2025-11-10 12:08:21.837634+00	049f7adf-d1fa-465f-bf3e-8fef5a519ff4
f2407bed-c06e-4e4d-b5e7-bafa7943d188	10000	1d99c72d-c219-4def-a3b9-f05c926d0c7f	2025-11-10 12:08:21.837634+00	d4de3459-36f0-40ee-834a-3f709006c12c
f2407bed-c06e-4e4d-b5e7-bafa7943d188	15000	a5a08373-c050-4dcf-b1b2-71010d5af5c1	2025-11-10 12:08:21.837634+00	b25a9aee-f026-42d2-98bd-ff4ad1997200
6bc12792-f762-443e-9d01-e8750993ee0e	6000	b1153f29-bab6-420b-90db-c45596f7de21	2025-11-10 14:31:44.007636+00	b61ace1f-1e5a-4e65-bb8f-b7d90fdc940a
6bc12792-f762-443e-9d01-e8750993ee0e	8000	b764c9ff-e7ec-4fe3-9892-da0b813b71ef	2025-11-10 14:31:44.007636+00	76eb6646-9c87-4026-a9ca-450eed5f06af
6bc12792-f762-443e-9d01-e8750993ee0e	12000	4d24e057-3401-4670-86aa-d24f73edd6b9	2025-11-10 14:31:44.007636+00	8e13ff4b-20dc-4b99-ac37-90d1989820db
c5a2994a-4aa7-4bc1-b0ee-bb687540f79e	4000	93fc0ac4-6cb3-40cd-a89d-f99d4494f5cd	2025-11-10 14:31:44.007636+00	b61ace1f-1e5a-4e65-bb8f-b7d90fdc940a
c5a2994a-4aa7-4bc1-b0ee-bb687540f79e	6000	4132d695-2da9-41b5-a288-cda3f04a8024	2025-11-10 14:31:44.007636+00	76eb6646-9c87-4026-a9ca-450eed5f06af
c5a2994a-4aa7-4bc1-b0ee-bb687540f79e	8000	78dd7b55-58b9-44b1-860d-08dc9b552ae6	2025-11-10 14:31:44.007636+00	8e13ff4b-20dc-4b99-ac37-90d1989820db
d49c620e-fb1a-4a8f-99bc-180666ae6220	20000	1e848d6b-a2b0-481d-ba5b-693cc37b91d8	2025-11-10 14:31:44.007636+00	b61ace1f-1e5a-4e65-bb8f-b7d90fdc940a
d49c620e-fb1a-4a8f-99bc-180666ae6220	25000	dd6022f3-b431-4cca-ab0f-5f14fd6667ca	2025-11-10 14:31:44.007636+00	76eb6646-9c87-4026-a9ca-450eed5f06af
d49c620e-fb1a-4a8f-99bc-180666ae6220	30000	91753b61-9f2c-400b-a19f-613bfa50ba13	2025-11-10 14:31:44.007636+00	8e13ff4b-20dc-4b99-ac37-90d1989820db
fefdd5ca-8866-4dab-9309-84bf505ef511	30000	4ad223a6-0371-43af-a20a-c69bd775b7da	2025-11-10 14:31:44.007636+00	b61ace1f-1e5a-4e65-bb8f-b7d90fdc940a
fefdd5ca-8866-4dab-9309-84bf505ef511	20000	2e9d960a-9491-4e7c-aea1-6d7a8d787b67	2025-11-10 14:31:44.007636+00	76eb6646-9c87-4026-a9ca-450eed5f06af
fefdd5ca-8866-4dab-9309-84bf505ef511	10000	d4b96a55-65f1-45ef-96b7-3398b954d1b1	2025-11-10 14:31:44.007636+00	8e13ff4b-20dc-4b99-ac37-90d1989820db
af647ebb-320a-421f-b224-3a5589e06f4d	5000	5f536cca-cc25-4959-8960-247ac3eebe7c	2025-11-10 14:31:44.007636+00	b61ace1f-1e5a-4e65-bb8f-b7d90fdc940a
af647ebb-320a-421f-b224-3a5589e06f4d	10000	bf4a6ae0-de68-4f64-ba71-00335f76339f	2025-11-10 14:31:44.007636+00	76eb6646-9c87-4026-a9ca-450eed5f06af
af647ebb-320a-421f-b224-3a5589e06f4d	15000	e2de357a-1ea2-484f-878e-686dc06d00d7	2025-11-10 14:31:44.007636+00	8e13ff4b-20dc-4b99-ac37-90d1989820db
578eae9d-c6e6-43b9-9fb3-011ff02129ae	5000	92630e8a-6827-4cae-b248-cb0541f2bc1e	2025-11-10 14:31:44.007636+00	b61ace1f-1e5a-4e65-bb8f-b7d90fdc940a
578eae9d-c6e6-43b9-9fb3-011ff02129ae	10000	51b5f669-5537-4c60-b578-e4224c3efb38	2025-11-10 14:31:44.007636+00	76eb6646-9c87-4026-a9ca-450eed5f06af
578eae9d-c6e6-43b9-9fb3-011ff02129ae	15000	8c50c859-d471-4b69-85c2-194b17c053e5	2025-11-10 14:31:44.007636+00	8e13ff4b-20dc-4b99-ac37-90d1989820db
0b7842b4-140e-4c87-b609-c641d244e9a2	6000	5e81441d-bead-4fc4-8dce-c22d748016cf	2025-11-12 23:20:09.904204+00	7cb26104-2032-4d69-91db-abe03a61dcf6
0b7842b4-140e-4c87-b609-c641d244e9a2	8000	a61a75de-64cb-48ad-b7c8-58bbd625c644	2025-11-12 23:20:09.904204+00	2ab15ba5-1727-4636-866f-22037a50e3e6
0b7842b4-140e-4c87-b609-c641d244e9a2	12000	9976afd2-94b1-4be8-9478-bd71556df0ff	2025-11-12 23:20:09.904204+00	8d5838e1-0f55-4e14-a54f-91ccc4f210e7
e7a3e1bf-522f-44e5-8518-bacc1587c0ab	4000	f2ad3fef-b133-4105-8d1e-030a849d619d	2025-11-12 23:20:09.904204+00	7cb26104-2032-4d69-91db-abe03a61dcf6
e7a3e1bf-522f-44e5-8518-bacc1587c0ab	6000	9bd0c640-538e-4500-b793-12c59a99d4b3	2025-11-12 23:20:09.904204+00	2ab15ba5-1727-4636-866f-22037a50e3e6
e7a3e1bf-522f-44e5-8518-bacc1587c0ab	8000	eb9df0f6-4dcc-4de5-83fa-524ecacc522c	2025-11-12 23:20:09.904204+00	8d5838e1-0f55-4e14-a54f-91ccc4f210e7
db7169e3-e443-4c74-9698-23ac71a5f9f0	20000	666eca2a-c5fd-43f7-ab02-89a8df761347	2025-11-12 23:20:09.904204+00	7cb26104-2032-4d69-91db-abe03a61dcf6
db7169e3-e443-4c74-9698-23ac71a5f9f0	25000	1978e8e7-7676-42dc-8ee8-dcc09f1dcae9	2025-11-12 23:20:09.904204+00	2ab15ba5-1727-4636-866f-22037a50e3e6
db7169e3-e443-4c74-9698-23ac71a5f9f0	30000	e4ecfbee-d3cd-4919-a268-585ba2c1154e	2025-11-12 23:20:09.904204+00	8d5838e1-0f55-4e14-a54f-91ccc4f210e7
01bba5e7-6a65-4ec2-927c-383be520c01c	30000	d61de112-ca7c-40e4-9b4a-6bedeb7056fb	2025-11-12 23:20:09.904204+00	7cb26104-2032-4d69-91db-abe03a61dcf6
01bba5e7-6a65-4ec2-927c-383be520c01c	20000	65aa6a86-9d48-4e8f-90aa-9a74cea83568	2025-11-12 23:20:09.904204+00	2ab15ba5-1727-4636-866f-22037a50e3e6
01bba5e7-6a65-4ec2-927c-383be520c01c	10000	806cbf11-948f-493b-8e10-605a37da76ef	2025-11-12 23:20:09.904204+00	8d5838e1-0f55-4e14-a54f-91ccc4f210e7
3a388245-4956-4f89-a399-8a9004003380	5000	ac0facec-1c35-4935-9232-a9725b99f0e0	2025-11-12 23:20:09.904204+00	7cb26104-2032-4d69-91db-abe03a61dcf6
3a388245-4956-4f89-a399-8a9004003380	10000	5dee2285-e282-4dd7-b026-52f4c3f11d62	2025-11-12 23:20:09.904204+00	2ab15ba5-1727-4636-866f-22037a50e3e6
3a388245-4956-4f89-a399-8a9004003380	15000	4cc64444-e932-4dd6-8fe8-6adf65a63dd8	2025-11-12 23:20:09.904204+00	8d5838e1-0f55-4e14-a54f-91ccc4f210e7
b8c56f1e-928a-4e8f-a890-23fd957b1801	5000	0a2ca3c2-8ce9-4d93-80b1-219854452daa	2025-11-12 23:20:09.904204+00	7cb26104-2032-4d69-91db-abe03a61dcf6
b8c56f1e-928a-4e8f-a890-23fd957b1801	10000	2ebe3dba-ab7c-4987-9b20-b15c0c44ec40	2025-11-12 23:20:09.904204+00	2ab15ba5-1727-4636-866f-22037a50e3e6
b8c56f1e-928a-4e8f-a890-23fd957b1801	15000	9e55e9ef-6156-4644-9d72-a8d5a877fceb	2025-11-12 23:20:09.904204+00	8d5838e1-0f55-4e14-a54f-91ccc4f210e7
3950254c-8f5d-4e88-817e-14c7d2dcac2a	4000	f7cc8228-5199-415d-8051-0d612a942b58	2025-11-18 23:04:09.953303+00	1a410093-18cc-46f7-9c14-28c356ac75c3
3950254c-8f5d-4e88-817e-14c7d2dcac2a	6000	bfaaf997-6529-41d1-8d06-b0c94c8654ab	2025-11-18 23:04:10.177307+00	f9e92872-603a-4a2f-a0c2-617ab0472d4b
3950254c-8f5d-4e88-817e-14c7d2dcac2a	8000	a66ffe51-d966-490a-bcf4-effb28a8c680	2025-11-18 23:04:10.398896+00	26dbce97-4e72-4e4c-83a2-2b06c6834dc0
23e40e3e-12a5-4b5d-9ca2-220c7a0d6c1f	6000	0aed7d34-2975-4251-8f4d-d86398727050	2025-12-26 02:01:09.782052+00	50be6b4e-2cef-499c-a660-6293a8f512bc
23e40e3e-12a5-4b5d-9ca2-220c7a0d6c1f	8000	d282c0e2-78ae-4c0a-b33e-9dd7a374efdd	2025-12-26 02:01:09.782052+00	af902c02-c6c2-47c5-addc-8f0ca2972104
23e40e3e-12a5-4b5d-9ca2-220c7a0d6c1f	12000	8db9a4a9-9a6a-4fd1-aa04-00c554d2e03e	2025-12-26 02:01:09.782052+00	bcc7536c-ac41-4390-8541-69d1b2bc29c6
94c29859-f311-47fc-985f-02877314c94d	4000	fb23a6d3-8a48-44a6-bc82-721577ff0b23	2025-12-26 02:01:09.782052+00	50be6b4e-2cef-499c-a660-6293a8f512bc
94c29859-f311-47fc-985f-02877314c94d	6000	8590ce02-367d-49af-b124-34f3c5bb8c82	2025-12-26 02:01:09.782052+00	af902c02-c6c2-47c5-addc-8f0ca2972104
94c29859-f311-47fc-985f-02877314c94d	8000	3e164246-934a-45f0-8d45-20d311111785	2025-12-26 02:01:09.782052+00	bcc7536c-ac41-4390-8541-69d1b2bc29c6
4bc50d6e-d0e5-41e1-bb69-23153e88841a	20000	e23c2dc2-348e-406d-a828-255db830d001	2025-12-26 02:01:09.782052+00	50be6b4e-2cef-499c-a660-6293a8f512bc
4bc50d6e-d0e5-41e1-bb69-23153e88841a	25000	bcf30924-3a83-43c3-81a4-a8ca54970097	2025-12-26 02:01:09.782052+00	af902c02-c6c2-47c5-addc-8f0ca2972104
1e7e09da-50e8-4627-85ea-2edc6c6d9616	6000	b7d99466-40de-4410-b27f-3e91a6cdad98	2025-11-29 11:50:50.649919+00	1a410093-18cc-46f7-9c14-28c356ac75c3
1e7e09da-50e8-4627-85ea-2edc6c6d9616	8000	b8aaf6e5-3917-485f-b45b-928fb4406e21	2025-11-29 11:50:50.877822+00	f9e92872-603a-4a2f-a0c2-617ab0472d4b
1e7e09da-50e8-4627-85ea-2edc6c6d9616	12000	71164a17-c56c-4608-bd8e-0fb4778beef1	2025-11-29 11:50:51.105767+00	26dbce97-4e72-4e4c-83a2-2b06c6834dc0
4bc50d6e-d0e5-41e1-bb69-23153e88841a	30000	8ea84462-c996-4c81-9a30-a94188a916fc	2025-12-26 02:01:09.782052+00	bcc7536c-ac41-4390-8541-69d1b2bc29c6
13bc9474-3d55-484a-958f-9c772b895bc8	30000	f5a6bd76-feb8-4bc9-9c9f-004045931e3d	2025-12-26 02:01:09.782052+00	50be6b4e-2cef-499c-a660-6293a8f512bc
13bc9474-3d55-484a-958f-9c772b895bc8	20000	f0cd8b76-8262-49ec-9402-93ab52e3e559	2025-12-26 02:01:09.782052+00	af902c02-c6c2-47c5-addc-8f0ca2972104
13bc9474-3d55-484a-958f-9c772b895bc8	10000	f637e323-7085-427c-9b5a-f49d02b32950	2025-12-26 02:01:09.782052+00	bcc7536c-ac41-4390-8541-69d1b2bc29c6
aaacfbdc-e890-40cf-af7e-15dfd8affed6	5000	89dce501-bf1c-4b32-b2b0-d5f99acd82d5	2025-12-26 02:01:09.782052+00	50be6b4e-2cef-499c-a660-6293a8f512bc
aaacfbdc-e890-40cf-af7e-15dfd8affed6	10000	1588ab6b-6de9-4cda-b666-bad36edc7d8f	2025-12-26 02:01:09.782052+00	af902c02-c6c2-47c5-addc-8f0ca2972104
aaacfbdc-e890-40cf-af7e-15dfd8affed6	15000	dafa5e31-b7c8-427d-9988-28c029743529	2025-12-26 02:01:09.782052+00	bcc7536c-ac41-4390-8541-69d1b2bc29c6
b0834ee9-5999-443e-bfbb-145cf521e9f8	5000	6c70de37-99f9-4f95-bcdf-83221c8da125	2025-12-26 02:01:09.782052+00	50be6b4e-2cef-499c-a660-6293a8f512bc
b0834ee9-5999-443e-bfbb-145cf521e9f8	10000	71a617f2-fadc-46d3-b0a0-a74c29c20376	2025-12-26 02:01:09.782052+00	af902c02-c6c2-47c5-addc-8f0ca2972104
b0834ee9-5999-443e-bfbb-145cf521e9f8	15000	fb2adf68-b6db-4cd2-b94e-687f5f5b4c28	2025-12-26 02:01:09.782052+00	bcc7536c-ac41-4390-8541-69d1b2bc29c6
98f635c7-7973-45e9-b643-980156f7ec7c	6000	2f8e8754-1fe9-4227-b766-2a6eda8aeb3c	2025-12-26 02:08:36.207421+00	fa0d48e7-5cd6-48eb-af16-161d1dcadc36
98f635c7-7973-45e9-b643-980156f7ec7c	8000	8ef20a28-dadc-45ad-a144-b880be723808	2025-12-26 02:08:36.207421+00	805c56df-8629-4e4a-bab7-9a044c30877f
98f635c7-7973-45e9-b643-980156f7ec7c	12000	67a24a0e-5eec-46eb-9fc6-2cae11d3fb01	2025-12-26 02:08:36.207421+00	e231c43a-ddd1-4e77-b60e-34f180f00ba3
efbd7e18-5d8c-4431-acb2-08a3ef5ae467	4000	83f734e0-a62e-4dec-b5d4-0fb8efe059a9	2025-12-26 02:08:36.207421+00	fa0d48e7-5cd6-48eb-af16-161d1dcadc36
efbd7e18-5d8c-4431-acb2-08a3ef5ae467	6000	b6c8ab18-fdee-46d0-a585-ffd1bcc1d78c	2025-12-26 02:08:36.207421+00	805c56df-8629-4e4a-bab7-9a044c30877f
efbd7e18-5d8c-4431-acb2-08a3ef5ae467	8000	3c80f932-6d4d-4442-992c-f1b3455b2369	2025-12-26 02:08:36.207421+00	e231c43a-ddd1-4e77-b60e-34f180f00ba3
4366e0da-b079-4d0c-82a9-49a3e3a15280	6000	063560d6-9e8a-4cb6-b385-4968b6ad0f1b	2025-12-24 11:58:58.634635+00	5a1a4a15-4f65-4bf4-96fd-516bea2d231a
4366e0da-b079-4d0c-82a9-49a3e3a15280	8000	58a61c8d-0b3d-4c0d-b596-403dcae7c782	2025-12-24 11:58:58.634635+00	7d104b0e-2c49-412f-a87c-90c7f8212679
4366e0da-b079-4d0c-82a9-49a3e3a15280	12000	70f9c108-2aa5-42b9-bab2-cd066fc9997d	2025-12-24 11:58:58.634635+00	ac36a51e-231b-4e10-ad26-1c368b67f3c1
bcbb862a-6c07-4230-b9f0-2640100d06af	4000	c9484088-13ac-46a9-8e7d-c284bf8e5561	2025-12-24 11:58:58.634635+00	5a1a4a15-4f65-4bf4-96fd-516bea2d231a
bcbb862a-6c07-4230-b9f0-2640100d06af	6000	e9923e44-6b76-45ae-8be4-7818767d2b3c	2025-12-24 11:58:58.634635+00	7d104b0e-2c49-412f-a87c-90c7f8212679
bcbb862a-6c07-4230-b9f0-2640100d06af	8000	bbae7a38-8985-49d9-bf80-105082c29b51	2025-12-24 11:58:58.634635+00	ac36a51e-231b-4e10-ad26-1c368b67f3c1
da628915-bf54-4ee6-a889-7ee4d47968ff	20000	caca5b54-d374-4886-87a4-2c273082d951	2025-12-24 11:58:58.634635+00	5a1a4a15-4f65-4bf4-96fd-516bea2d231a
da628915-bf54-4ee6-a889-7ee4d47968ff	25000	d66deed4-7cee-4f5c-9501-ed48ffda8d39	2025-12-24 11:58:58.634635+00	7d104b0e-2c49-412f-a87c-90c7f8212679
da628915-bf54-4ee6-a889-7ee4d47968ff	30000	5a0d441f-c312-4624-8719-97d36e5c0b9d	2025-12-24 11:58:58.634635+00	ac36a51e-231b-4e10-ad26-1c368b67f3c1
56ef1d13-edf2-4eaa-8c64-e551f9603865	30000	bf92563e-f929-436e-a58c-2c27167f67d5	2025-12-24 11:58:58.634635+00	5a1a4a15-4f65-4bf4-96fd-516bea2d231a
56ef1d13-edf2-4eaa-8c64-e551f9603865	20000	3a25beff-06fb-43e5-9e87-837526550da0	2025-12-24 11:58:58.634635+00	7d104b0e-2c49-412f-a87c-90c7f8212679
56ef1d13-edf2-4eaa-8c64-e551f9603865	10000	6caf710e-78eb-4e54-a842-fbe9ca6facfe	2025-12-24 11:58:58.634635+00	ac36a51e-231b-4e10-ad26-1c368b67f3c1
264537bc-7c2d-4508-b270-9b1297d3d780	5000	43b2c28e-85e7-4d56-9fd2-e711274050ad	2025-12-24 11:58:58.634635+00	5a1a4a15-4f65-4bf4-96fd-516bea2d231a
264537bc-7c2d-4508-b270-9b1297d3d780	10000	edd9e06a-329a-425a-8167-152581c885fb	2025-12-24 11:58:58.634635+00	7d104b0e-2c49-412f-a87c-90c7f8212679
264537bc-7c2d-4508-b270-9b1297d3d780	15000	6eecbbe0-ad69-4a3a-9563-68de6a824c7f	2025-12-24 11:58:58.634635+00	ac36a51e-231b-4e10-ad26-1c368b67f3c1
37909974-750d-44fb-8054-201b47aa1313	5000	d351d31c-66c8-48f1-904f-8831ea05eb94	2025-12-24 11:58:58.634635+00	5a1a4a15-4f65-4bf4-96fd-516bea2d231a
37909974-750d-44fb-8054-201b47aa1313	10000	49f5b54a-1086-4640-92c6-5263509516ea	2025-12-24 11:58:58.634635+00	7d104b0e-2c49-412f-a87c-90c7f8212679
37909974-750d-44fb-8054-201b47aa1313	15000	e03fe06b-d82c-4f7f-95dc-698e737199dd	2025-12-24 11:58:58.634635+00	ac36a51e-231b-4e10-ad26-1c368b67f3c1
f802a4ac-ce12-4397-9f58-e2e894af093a	6000	ee8b1ef9-bb66-4016-8da7-67f4d556ff42	2025-12-24 12:05:47.624747+00	b77a9478-b992-46c5-8525-7dbd810b861e
f802a4ac-ce12-4397-9f58-e2e894af093a	8000	af37166f-190f-464f-a676-1671fa04b64e	2025-12-24 12:05:47.624747+00	003e5e86-44de-43c4-a6cf-297105572276
f802a4ac-ce12-4397-9f58-e2e894af093a	12000	1130d628-7cad-4f50-a2a7-4600334b4839	2025-12-24 12:05:47.624747+00	e27f79a4-4293-455b-adcc-b9ea6f4bc1ff
973dff2a-3c4c-4689-8380-a61626aeb325	4000	c8703e76-b34c-47ae-abdc-5974cdfa5639	2025-12-24 12:05:47.624747+00	b77a9478-b992-46c5-8525-7dbd810b861e
973dff2a-3c4c-4689-8380-a61626aeb325	6000	4f5689f7-5263-4f90-ba28-c616bb444c0e	2025-12-24 12:05:47.624747+00	003e5e86-44de-43c4-a6cf-297105572276
973dff2a-3c4c-4689-8380-a61626aeb325	8000	ff5df45c-c6ce-486c-8d27-99661dbf8edc	2025-12-24 12:05:47.624747+00	e27f79a4-4293-455b-adcc-b9ea6f4bc1ff
5077a326-07d2-4077-852e-794689eeefa7	20000	1822da46-eaf5-45fd-bec1-32bb44aaa7fe	2025-12-24 12:05:47.624747+00	b77a9478-b992-46c5-8525-7dbd810b861e
5077a326-07d2-4077-852e-794689eeefa7	25000	39ef001c-f339-4b4c-afab-1ae5ac3a2099	2025-12-24 12:05:47.624747+00	003e5e86-44de-43c4-a6cf-297105572276
5077a326-07d2-4077-852e-794689eeefa7	30000	3bebe3b4-c1e8-4302-819f-d33b48fbb586	2025-12-24 12:05:47.624747+00	e27f79a4-4293-455b-adcc-b9ea6f4bc1ff
372efe29-88dd-4205-8147-a25c13e8aa26	30000	1e394d73-1e02-41c5-9176-9bcfb2760605	2025-12-24 12:05:47.624747+00	b77a9478-b992-46c5-8525-7dbd810b861e
372efe29-88dd-4205-8147-a25c13e8aa26	20000	ca1d049c-f533-4d07-800c-ff5f5c960ee6	2025-12-24 12:05:47.624747+00	003e5e86-44de-43c4-a6cf-297105572276
372efe29-88dd-4205-8147-a25c13e8aa26	10000	a5d4a974-9876-4a9c-83de-b2806baa69df	2025-12-24 12:05:47.624747+00	e27f79a4-4293-455b-adcc-b9ea6f4bc1ff
c0b0e1d6-2c84-4113-9902-a49b68dd99c2	5000	ce88e423-5feb-4958-9f63-846111f012e6	2025-12-24 12:05:47.624747+00	b77a9478-b992-46c5-8525-7dbd810b861e
c0b0e1d6-2c84-4113-9902-a49b68dd99c2	10000	36eca1b9-63d8-4c6e-88c9-22959cc07a09	2025-12-24 12:05:47.624747+00	003e5e86-44de-43c4-a6cf-297105572276
c0b0e1d6-2c84-4113-9902-a49b68dd99c2	15000	ca2cb141-254d-4528-a56b-155c1c260b60	2025-12-24 12:05:47.624747+00	e27f79a4-4293-455b-adcc-b9ea6f4bc1ff
45508d99-9adb-4a00-bcc2-5a400b869bd3	5000	2fefd5fa-d535-42fb-ab16-ab1e6646052c	2025-12-24 12:05:47.624747+00	b77a9478-b992-46c5-8525-7dbd810b861e
45508d99-9adb-4a00-bcc2-5a400b869bd3	10000	19a02c1d-00e4-4e0c-bc92-218792fbe20f	2025-12-24 12:05:47.624747+00	003e5e86-44de-43c4-a6cf-297105572276
45508d99-9adb-4a00-bcc2-5a400b869bd3	15000	31ccc71c-7f23-4bb1-821b-fa884fbc22c2	2025-12-24 12:05:47.624747+00	e27f79a4-4293-455b-adcc-b9ea6f4bc1ff
601ef8e1-9b64-4c3c-ada6-09b1aa37478b	6000	33f7caf7-33c6-470a-8af1-0f27091b983f	2025-12-24 12:09:41.331645+00	a1224d64-4c38-4cea-84a5-393afba2bc2d
601ef8e1-9b64-4c3c-ada6-09b1aa37478b	8000	0942a22c-4466-41d3-b8fe-23c28a0ad04f	2025-12-24 12:09:41.331645+00	19b18fd4-0887-418a-9a40-df3a476f25e5
601ef8e1-9b64-4c3c-ada6-09b1aa37478b	12000	1d5f1e53-7693-4903-96de-fec3335486c0	2025-12-24 12:09:41.331645+00	7932cbf9-8ba8-470d-940d-a9c7054b5091
35dbabfb-9967-461e-90f1-7b4152d14d40	4000	1adbfc93-6e12-4465-95c8-aa16421262e7	2025-12-24 12:09:41.331645+00	a1224d64-4c38-4cea-84a5-393afba2bc2d
35dbabfb-9967-461e-90f1-7b4152d14d40	6000	6036b9c1-5de1-4a53-9108-e837333eb02c	2025-12-24 12:09:41.331645+00	19b18fd4-0887-418a-9a40-df3a476f25e5
35dbabfb-9967-461e-90f1-7b4152d14d40	8000	e1064016-4331-479e-b403-1703d7d091d1	2025-12-24 12:09:41.331645+00	7932cbf9-8ba8-470d-940d-a9c7054b5091
11a96658-4255-4fa4-84ec-747b390a0eda	20000	4a8099cc-0c12-44d7-89f8-3bd0321fee5a	2025-12-24 12:09:41.331645+00	a1224d64-4c38-4cea-84a5-393afba2bc2d
11a96658-4255-4fa4-84ec-747b390a0eda	25000	3f94c76d-3a39-42d0-bba1-099f82e19c48	2025-12-24 12:09:41.331645+00	19b18fd4-0887-418a-9a40-df3a476f25e5
11a96658-4255-4fa4-84ec-747b390a0eda	30000	5959430c-bfa2-41f4-95ff-8d55ddd23ec4	2025-12-24 12:09:41.331645+00	7932cbf9-8ba8-470d-940d-a9c7054b5091
bb9dd608-475d-4bf4-abf8-794559d73f0e	30000	02bb48ee-cdab-4ea6-b6e0-57e5aa73a72c	2025-12-24 12:09:41.331645+00	a1224d64-4c38-4cea-84a5-393afba2bc2d
bb9dd608-475d-4bf4-abf8-794559d73f0e	20000	d122ad1e-1c5c-42ac-b02c-555c6f3e181a	2025-12-24 12:09:41.331645+00	19b18fd4-0887-418a-9a40-df3a476f25e5
bb9dd608-475d-4bf4-abf8-794559d73f0e	10000	36b9e03f-4fdd-4df8-a602-4642b0bbea5c	2025-12-24 12:09:41.331645+00	7932cbf9-8ba8-470d-940d-a9c7054b5091
ade6dba0-5dee-4ef1-88ff-39e42a91696a	5000	b23fdee5-1d92-4382-890e-7ddc560f9a69	2025-12-24 12:09:41.331645+00	a1224d64-4c38-4cea-84a5-393afba2bc2d
ade6dba0-5dee-4ef1-88ff-39e42a91696a	10000	0e9c7443-9747-4874-b1f4-57e4f7658ee2	2025-12-24 12:09:41.331645+00	19b18fd4-0887-418a-9a40-df3a476f25e5
ade6dba0-5dee-4ef1-88ff-39e42a91696a	15000	e36bdbfb-3c83-4108-bf11-6f780857b2a4	2025-12-24 12:09:41.331645+00	7932cbf9-8ba8-470d-940d-a9c7054b5091
551b01f6-3065-447f-93cf-4f07b9c63282	5000	483e2489-081f-418f-afda-e154e7995860	2025-12-24 12:09:41.331645+00	a1224d64-4c38-4cea-84a5-393afba2bc2d
551b01f6-3065-447f-93cf-4f07b9c63282	10000	0bbcbf5c-2b93-46cd-91b0-7b465a0135fb	2025-12-24 12:09:41.331645+00	19b18fd4-0887-418a-9a40-df3a476f25e5
551b01f6-3065-447f-93cf-4f07b9c63282	15000	4a1b951b-3b01-426d-a0ff-84508ace15b6	2025-12-24 12:09:41.331645+00	7932cbf9-8ba8-470d-940d-a9c7054b5091
16af5fee-10c8-4788-99a5-410593e22116	20000	cde1ca1d-2cb5-4c57-b11a-0a9f1f9eca4b	2025-12-26 02:08:36.207421+00	fa0d48e7-5cd6-48eb-af16-161d1dcadc36
16af5fee-10c8-4788-99a5-410593e22116	25000	425a351c-6c87-46b6-a7b6-55497dffa7e2	2025-12-26 02:08:36.207421+00	805c56df-8629-4e4a-bab7-9a044c30877f
16af5fee-10c8-4788-99a5-410593e22116	30000	57fad328-d1d0-4d4a-91e0-33a99aedd38a	2025-12-26 02:08:36.207421+00	e231c43a-ddd1-4e77-b60e-34f180f00ba3
7b5f80b7-6ed2-43a7-b622-8d4f35557686	30000	4c842d8f-acb7-4d79-8216-db4a959595da	2025-12-26 02:08:36.207421+00	fa0d48e7-5cd6-48eb-af16-161d1dcadc36
7b5f80b7-6ed2-43a7-b622-8d4f35557686	20000	ebe3ee9a-d8a9-4154-aa59-966c50e5fc89	2025-12-26 02:08:36.207421+00	805c56df-8629-4e4a-bab7-9a044c30877f
7b5f80b7-6ed2-43a7-b622-8d4f35557686	10000	3b045513-f8cb-4dca-9f74-055e79c12c58	2025-12-26 02:08:36.207421+00	e231c43a-ddd1-4e77-b60e-34f180f00ba3
9fa58609-404b-4ac0-a23f-6f136cf5da82	5000	63a0f30d-15eb-4bde-8e37-c20b7180f223	2025-12-26 02:08:36.207421+00	fa0d48e7-5cd6-48eb-af16-161d1dcadc36
9fa58609-404b-4ac0-a23f-6f136cf5da82	10000	25fc9071-bc3b-4bf0-8fa8-139cc856500b	2025-12-26 02:08:36.207421+00	805c56df-8629-4e4a-bab7-9a044c30877f
9fa58609-404b-4ac0-a23f-6f136cf5da82	15000	ecb6dffa-626b-45d9-b6bc-2b802527f234	2025-12-26 02:08:36.207421+00	e231c43a-ddd1-4e77-b60e-34f180f00ba3
f6ae74ac-32bd-40dd-a91f-c839684c5074	5000	be1e09f9-5b9a-4c09-b226-97dc69e20297	2025-12-26 02:08:36.207421+00	fa0d48e7-5cd6-48eb-af16-161d1dcadc36
f6ae74ac-32bd-40dd-a91f-c839684c5074	10000	0b878ac6-e6cd-4838-8fe9-28017aedb391	2025-12-26 02:08:36.207421+00	805c56df-8629-4e4a-bab7-9a044c30877f
f6ae74ac-32bd-40dd-a91f-c839684c5074	15000	db0f2dbd-9471-4077-be46-8f88c2362fb3	2025-12-26 02:08:36.207421+00	e231c43a-ddd1-4e77-b60e-34f180f00ba3
48bd244b-05c5-471f-8d62-873cef0f4ead	6000	a07d9727-1816-4954-bd16-0311ec7e4d6a	2025-12-26 02:09:09.744311+00	6015168c-055c-455e-b685-40b452247c32
48bd244b-05c5-471f-8d62-873cef0f4ead	8000	207147aa-747e-4104-bf9b-6b61ce5184fd	2025-12-26 02:09:09.744311+00	246bb5f2-aba9-4073-a1e3-d070171f6871
48bd244b-05c5-471f-8d62-873cef0f4ead	12000	a99af2d4-2b6b-4e3d-b9fb-47a1c6dcbcad	2025-12-26 02:09:09.744311+00	afd609b8-0b82-4161-89eb-45db45c4a410
dac5402d-98b2-4d69-927e-1943baf75f07	4000	472cc2ac-4983-479e-afa0-0b3889aa902a	2025-12-26 02:09:09.744311+00	6015168c-055c-455e-b685-40b452247c32
dac5402d-98b2-4d69-927e-1943baf75f07	6000	c11e0f31-0aac-498d-82a5-28fe79aa0a0b	2025-12-26 02:09:09.744311+00	246bb5f2-aba9-4073-a1e3-d070171f6871
dac5402d-98b2-4d69-927e-1943baf75f07	8000	12e6c62c-4fc4-4adc-bb03-7facf29efce3	2025-12-26 02:09:09.744311+00	afd609b8-0b82-4161-89eb-45db45c4a410
049a7886-8a79-49ad-911e-e8651a116689	20000	374aa319-f157-4b96-ac19-0cf0ca5901be	2025-12-26 02:09:09.744311+00	6015168c-055c-455e-b685-40b452247c32
049a7886-8a79-49ad-911e-e8651a116689	25000	9d63e409-6663-4f59-aa4f-70ebd6f93356	2025-12-26 02:09:09.744311+00	246bb5f2-aba9-4073-a1e3-d070171f6871
049a7886-8a79-49ad-911e-e8651a116689	30000	2190f718-ad12-42e2-9b4c-3696b808475f	2025-12-26 02:09:09.744311+00	afd609b8-0b82-4161-89eb-45db45c4a410
5f71d04a-5d80-4fc0-8eee-eccd74f631af	30000	022fd69f-e0e9-4db9-9a52-b6ba4cbb7aae	2025-12-26 02:09:09.744311+00	6015168c-055c-455e-b685-40b452247c32
5f71d04a-5d80-4fc0-8eee-eccd74f631af	20000	0bac4d77-2bf9-40dd-b4ca-1908eee43d7b	2025-12-26 02:09:09.744311+00	246bb5f2-aba9-4073-a1e3-d070171f6871
5f71d04a-5d80-4fc0-8eee-eccd74f631af	10000	e56d91bf-cac0-4434-884a-ca99edf5f835	2025-12-26 02:09:09.744311+00	afd609b8-0b82-4161-89eb-45db45c4a410
a58a3658-e442-4ec4-a624-cdb624f5fb95	5000	7cdcef38-50b2-48d0-8b20-bfa67e4d4749	2025-12-26 02:09:09.744311+00	6015168c-055c-455e-b685-40b452247c32
a58a3658-e442-4ec4-a624-cdb624f5fb95	10000	ceb57da7-b454-458e-86af-b6b5ed9569e2	2025-12-26 02:09:09.744311+00	246bb5f2-aba9-4073-a1e3-d070171f6871
a58a3658-e442-4ec4-a624-cdb624f5fb95	15000	79b976e0-6792-48a1-aeee-de0eb03999d8	2025-12-26 02:09:09.744311+00	afd609b8-0b82-4161-89eb-45db45c4a410
0798b241-f35e-401d-a2e0-a1941539a66f	5000	0d789088-5cfc-4464-9cac-ec937ba53806	2025-12-26 02:09:09.744311+00	6015168c-055c-455e-b685-40b452247c32
0798b241-f35e-401d-a2e0-a1941539a66f	10000	f722ee6a-84ed-476b-91af-71582c36425b	2025-12-26 02:09:09.744311+00	246bb5f2-aba9-4073-a1e3-d070171f6871
0798b241-f35e-401d-a2e0-a1941539a66f	15000	d578fe76-45e8-4aae-a786-0de91d94cdf0	2025-12-26 02:09:09.744311+00	afd609b8-0b82-4161-89eb-45db45c4a410
2ce6b302-43f0-4fb8-9ca3-93a0cc06e7b9	6000	28c15e64-c5a6-4c9f-b743-33f8876d8c5d	2025-12-29 13:47:33.752859+00	a0236724-49ec-4f77-b5b4-7f0faba0e7d7
2ce6b302-43f0-4fb8-9ca3-93a0cc06e7b9	8000	b8af340c-b3b6-4139-a1df-7ee65c25d24f	2025-12-29 13:47:33.752859+00	0d031481-e6c6-4f1c-bc0f-e7e552df1a91
2ce6b302-43f0-4fb8-9ca3-93a0cc06e7b9	12000	65d2d962-0447-49b7-b1a1-fca590462e3d	2025-12-29 13:47:33.752859+00	80f52e3a-797a-4b86-a660-9b60f93d7681
5634dd10-dae5-4c59-8fab-aeab90926e0a	4000	0e8749a8-b48a-4292-bbc2-5ca437c124de	2025-12-29 13:47:33.752859+00	a0236724-49ec-4f77-b5b4-7f0faba0e7d7
5634dd10-dae5-4c59-8fab-aeab90926e0a	6000	bcd8f210-92ea-4155-974c-4c3aba285a88	2025-12-29 13:47:33.752859+00	0d031481-e6c6-4f1c-bc0f-e7e552df1a91
5634dd10-dae5-4c59-8fab-aeab90926e0a	8000	826a10ea-8d00-4799-b56d-64d369e4e052	2025-12-29 13:47:33.752859+00	80f52e3a-797a-4b86-a660-9b60f93d7681
95dffe87-7bdb-4ba6-9b17-ab2f28ba986c	20000	1eacbbe6-c72e-4fb6-9d3d-22d72b500801	2025-12-29 13:47:33.752859+00	a0236724-49ec-4f77-b5b4-7f0faba0e7d7
95dffe87-7bdb-4ba6-9b17-ab2f28ba986c	25000	bbbb8cfd-be2f-478a-97e8-9de9f0d684f4	2025-12-29 13:47:33.752859+00	0d031481-e6c6-4f1c-bc0f-e7e552df1a91
95dffe87-7bdb-4ba6-9b17-ab2f28ba986c	30000	d166e491-2cb9-4636-a423-df93abf217f5	2025-12-29 13:47:33.752859+00	80f52e3a-797a-4b86-a660-9b60f93d7681
7600ed94-89a0-4610-8568-293567df299f	30000	94a4a03d-be9f-4a6d-a2b3-c5ca8024d8d2	2025-12-29 13:47:33.752859+00	a0236724-49ec-4f77-b5b4-7f0faba0e7d7
7600ed94-89a0-4610-8568-293567df299f	20000	e34ca73c-4dda-4947-8363-a075dfc227ad	2025-12-29 13:47:33.752859+00	0d031481-e6c6-4f1c-bc0f-e7e552df1a91
7600ed94-89a0-4610-8568-293567df299f	10000	72eba756-78f6-4ea4-ba3f-5268113527a2	2025-12-29 13:47:33.752859+00	80f52e3a-797a-4b86-a660-9b60f93d7681
68f69f29-8bca-4773-a74f-dca264f67796	5000	30e22d59-c428-42cc-9c01-d1c3ecb2d183	2025-12-29 13:47:33.752859+00	a0236724-49ec-4f77-b5b4-7f0faba0e7d7
68f69f29-8bca-4773-a74f-dca264f67796	10000	1b54a9cb-5664-4ba4-946e-55d71ed6fbc7	2025-12-29 13:47:33.752859+00	0d031481-e6c6-4f1c-bc0f-e7e552df1a91
68f69f29-8bca-4773-a74f-dca264f67796	15000	006778f3-8fe4-4f8f-9eae-f207abc28241	2025-12-29 13:47:33.752859+00	80f52e3a-797a-4b86-a660-9b60f93d7681
51129e3b-bc57-4830-8884-cb365400f7cf	5000	ccf35202-8574-4976-a090-793bc26ba158	2025-12-29 13:47:33.752859+00	a0236724-49ec-4f77-b5b4-7f0faba0e7d7
51129e3b-bc57-4830-8884-cb365400f7cf	10000	85d6d666-12f5-4ea6-854f-db2bec251ad1	2025-12-29 13:47:33.752859+00	0d031481-e6c6-4f1c-bc0f-e7e552df1a91
51129e3b-bc57-4830-8884-cb365400f7cf	15000	258b902c-2bdf-40d0-9bc3-ee32d3fbffbf	2025-12-29 13:47:33.752859+00	80f52e3a-797a-4b86-a660-9b60f93d7681
42d46274-b70c-4f5d-a4c6-5ee8360d1a86	6000	297bd4ed-f8f0-47f9-a582-6251fa7627d4	2025-12-29 13:56:31.2994+00	99a0e713-2045-44d8-a222-728f1d81446f
42d46274-b70c-4f5d-a4c6-5ee8360d1a86	8000	45efe074-2821-48e2-83a1-3341b5f4f95d	2025-12-29 13:56:31.2994+00	7560b232-73ff-4912-9f6a-10602d0ad2b1
42d46274-b70c-4f5d-a4c6-5ee8360d1a86	12000	27d45270-2936-449d-84c3-d780f5388e81	2025-12-29 13:56:31.2994+00	2d285880-7229-48db-8f57-44b54813698c
39e39e3e-6627-4064-afdc-f297eb94542d	4000	abe082de-aa46-4e90-bce0-80cb67935fbc	2025-12-29 13:56:31.2994+00	99a0e713-2045-44d8-a222-728f1d81446f
39e39e3e-6627-4064-afdc-f297eb94542d	6000	0d2d7310-646b-46e3-9ec9-b4ba9053577e	2025-12-29 13:56:31.2994+00	7560b232-73ff-4912-9f6a-10602d0ad2b1
39e39e3e-6627-4064-afdc-f297eb94542d	8000	ff3a078b-9fac-4c39-8fa0-d0155a7f52b6	2025-12-29 13:56:31.2994+00	2d285880-7229-48db-8f57-44b54813698c
b4fc1633-fe39-4013-9145-34fe30b9a3ca	20000	d0934734-618d-44a8-991f-ae33af71115e	2025-12-29 13:56:31.2994+00	99a0e713-2045-44d8-a222-728f1d81446f
b4fc1633-fe39-4013-9145-34fe30b9a3ca	25000	4d64b8ca-55d2-4405-ae23-914eeb7ce38b	2025-12-29 13:56:31.2994+00	7560b232-73ff-4912-9f6a-10602d0ad2b1
b4fc1633-fe39-4013-9145-34fe30b9a3ca	30000	457a7648-08fe-4816-811a-b090615aabdb	2025-12-29 13:56:31.2994+00	2d285880-7229-48db-8f57-44b54813698c
92c55d81-8cb1-4730-b9a8-dd04bfbaf7d7	30000	890e971e-c187-4f21-8e4a-78319c715abb	2025-12-29 13:56:31.2994+00	99a0e713-2045-44d8-a222-728f1d81446f
92c55d81-8cb1-4730-b9a8-dd04bfbaf7d7	20000	c54ad179-6dcc-4222-8e9c-eea95fc4cdd6	2025-12-29 13:56:31.2994+00	7560b232-73ff-4912-9f6a-10602d0ad2b1
92c55d81-8cb1-4730-b9a8-dd04bfbaf7d7	10000	8587005a-d2ac-4c70-a495-9739c2593812	2025-12-29 13:56:31.2994+00	2d285880-7229-48db-8f57-44b54813698c
6be12983-16f9-48d3-99fc-7d9c775af80f	5000	05fd2264-903f-475b-8828-f9b1c5127265	2025-12-29 13:56:31.2994+00	99a0e713-2045-44d8-a222-728f1d81446f
6be12983-16f9-48d3-99fc-7d9c775af80f	10000	4419bbff-e45b-4277-b725-57414dcb00c7	2025-12-29 13:56:31.2994+00	7560b232-73ff-4912-9f6a-10602d0ad2b1
6be12983-16f9-48d3-99fc-7d9c775af80f	15000	8ca7ee90-c007-4e7d-9e5f-12959ef673e2	2025-12-29 13:56:31.2994+00	2d285880-7229-48db-8f57-44b54813698c
bc282bc7-e577-4e97-9fa4-5d5b43f37bdf	5000	803d2e5c-1197-4bca-ba99-bb9038c5d655	2025-12-29 13:56:31.2994+00	99a0e713-2045-44d8-a222-728f1d81446f
bc282bc7-e577-4e97-9fa4-5d5b43f37bdf	10000	11921f64-064f-47a3-8af3-726824e5bc40	2025-12-29 13:56:31.2994+00	7560b232-73ff-4912-9f6a-10602d0ad2b1
bc282bc7-e577-4e97-9fa4-5d5b43f37bdf	15000	a82d1b21-f186-4631-a469-19b9b4803c92	2025-12-29 13:56:31.2994+00	2d285880-7229-48db-8f57-44b54813698c
c6dd7400-8c3d-4dda-9327-97223f4c99b1	6000	f91d5e81-f99a-49b7-b909-d70873b9c3f0	2025-12-29 14:01:00.127012+00	79798fa5-eca2-4925-bb82-6be3e500fc56
c6dd7400-8c3d-4dda-9327-97223f4c99b1	8000	d4aed90b-c284-4383-ad6e-175bba715050	2025-12-29 14:01:00.127012+00	7e6846dd-78c8-4c65-bbe9-0df70e15e316
c6dd7400-8c3d-4dda-9327-97223f4c99b1	12000	77fc40c4-e6fb-4c79-903d-c31b6298755f	2025-12-29 14:01:00.127012+00	2a098950-d5a1-499a-8cc6-4f36e6bda64c
4190e027-ede3-4f33-8a52-cc8182dc149e	4000	0a6ef52c-4fa5-4670-a8e4-34c9a6b30671	2025-12-29 14:01:00.127012+00	79798fa5-eca2-4925-bb82-6be3e500fc56
4190e027-ede3-4f33-8a52-cc8182dc149e	6000	2e8b7774-bdc3-44e9-8ba6-d544d6b2ea5b	2025-12-29 14:01:00.127012+00	7e6846dd-78c8-4c65-bbe9-0df70e15e316
4190e027-ede3-4f33-8a52-cc8182dc149e	8000	094bcffa-6257-43db-bb45-8c203529bd5a	2025-12-29 14:01:00.127012+00	2a098950-d5a1-499a-8cc6-4f36e6bda64c
374ffadf-363a-4898-94a1-c57f94ca9358	20000	82478e0a-e98b-4e3f-8a56-f400d5ceeab0	2025-12-29 14:01:00.127012+00	79798fa5-eca2-4925-bb82-6be3e500fc56
374ffadf-363a-4898-94a1-c57f94ca9358	25000	3735c59d-29e0-4e8b-9455-29d432465140	2025-12-29 14:01:00.127012+00	7e6846dd-78c8-4c65-bbe9-0df70e15e316
374ffadf-363a-4898-94a1-c57f94ca9358	30000	55b1d1c3-2a21-471d-9d07-dc257a0e8121	2025-12-29 14:01:00.127012+00	2a098950-d5a1-499a-8cc6-4f36e6bda64c
3d5f3555-1146-4ce1-87dd-e1f7e8ef8dfd	30000	0232ea4b-33c7-49ec-8712-2c1ebd1bd53b	2025-12-29 14:01:00.127012+00	79798fa5-eca2-4925-bb82-6be3e500fc56
3d5f3555-1146-4ce1-87dd-e1f7e8ef8dfd	20000	c3adb585-0924-453e-b39f-5eedd0b09f19	2025-12-29 14:01:00.127012+00	7e6846dd-78c8-4c65-bbe9-0df70e15e316
3d5f3555-1146-4ce1-87dd-e1f7e8ef8dfd	10000	966c13dc-04bb-4f18-88ff-1e678497c3e7	2025-12-29 14:01:00.127012+00	2a098950-d5a1-499a-8cc6-4f36e6bda64c
2376346c-b674-4910-8415-69bba60dd821	5000	daffb7ea-06d5-444a-9ddb-91077aa0d0e7	2025-12-29 14:01:00.127012+00	79798fa5-eca2-4925-bb82-6be3e500fc56
2376346c-b674-4910-8415-69bba60dd821	10000	9fcbdfd7-5717-48bf-9f98-99ed1d9eca15	2025-12-29 14:01:00.127012+00	7e6846dd-78c8-4c65-bbe9-0df70e15e316
8f1cdf48-5638-4fc6-8a56-0456533b17ec	4000	a04dd9fc-4a8c-43a6-ba7c-228c46f6d8d2	2025-12-29 14:02:53.837645+00	587712b4-77d7-4c30-988a-723a5b7695dd
8f1cdf48-5638-4fc6-8a56-0456533b17ec	6000	0e6c3e9e-462a-454b-8e33-d3795166a4de	2025-12-29 14:02:53.837645+00	c88faf7d-86fa-4965-b72c-4e2362726cd0
8f1cdf48-5638-4fc6-8a56-0456533b17ec	8000	dfed4899-58cf-4495-9db3-86316baf1452	2025-12-29 14:02:53.837645+00	b35f4309-d4c3-4e75-ac46-cd12a807f08a
7b886772-a94b-4234-89b9-c7ed06bebc3a	20000	c4c769c0-bc87-4463-b6ea-472f2e20f858	2025-12-29 14:02:53.837645+00	587712b4-77d7-4c30-988a-723a5b7695dd
7b886772-a94b-4234-89b9-c7ed06bebc3a	25000	5c184e1a-1073-4508-b6ce-9b7d52bc1931	2025-12-29 14:02:53.837645+00	c88faf7d-86fa-4965-b72c-4e2362726cd0
7b886772-a94b-4234-89b9-c7ed06bebc3a	30000	1e2633f0-448b-44e6-826f-ddd2f64c6eae	2025-12-29 14:02:53.837645+00	b35f4309-d4c3-4e75-ac46-cd12a807f08a
9aebc110-8f3b-4240-9608-e8bcef35ca3f	30000	ffc3b419-1616-4a1e-ad36-f8fa131795e8	2025-12-29 14:02:53.837645+00	587712b4-77d7-4c30-988a-723a5b7695dd
9aebc110-8f3b-4240-9608-e8bcef35ca3f	20000	dfba76dc-d43d-4306-b667-a17ce6be55d8	2025-12-29 14:02:53.837645+00	c88faf7d-86fa-4965-b72c-4e2362726cd0
9aebc110-8f3b-4240-9608-e8bcef35ca3f	10000	dbaecbce-8512-45bb-bd3c-0bd6b57c8303	2025-12-29 14:02:53.837645+00	b35f4309-d4c3-4e75-ac46-cd12a807f08a
fa268402-6546-4f30-90aa-e1f943c5fc12	5000	2487714c-b573-47b1-a991-24270422788b	2025-12-29 14:02:53.837645+00	587712b4-77d7-4c30-988a-723a5b7695dd
fa268402-6546-4f30-90aa-e1f943c5fc12	10000	08a9640a-976a-4ef1-bf70-77474c9a6ad8	2025-12-29 14:02:53.837645+00	c88faf7d-86fa-4965-b72c-4e2362726cd0
fa268402-6546-4f30-90aa-e1f943c5fc12	15000	02dbf259-6283-44e0-a4e6-bff564589a0e	2025-12-29 14:02:53.837645+00	b35f4309-d4c3-4e75-ac46-cd12a807f08a
01b50669-527e-45bb-865f-08427b48e7f8	5000	993747f3-4108-4acd-940a-99af55693fa2	2025-12-29 14:02:53.837645+00	587712b4-77d7-4c30-988a-723a5b7695dd
01b50669-527e-45bb-865f-08427b48e7f8	10000	e967f37c-5cb2-4295-b318-f47262eadc6d	2025-12-29 14:02:53.837645+00	c88faf7d-86fa-4965-b72c-4e2362726cd0
01b50669-527e-45bb-865f-08427b48e7f8	15000	de70e877-6c10-4f82-8157-b9c9171e6dcd	2025-12-29 14:02:53.837645+00	b35f4309-d4c3-4e75-ac46-cd12a807f08a
e186215f-2464-4584-980e-36ec5ebe0285	6000	f3b34aeb-2845-4bd8-97d3-93908e7d6232	2025-12-29 14:04:59.02137+00	042a9a56-7188-4367-9b59-9cd1ca25fc55
e186215f-2464-4584-980e-36ec5ebe0285	8000	7a18e5f6-4c4b-4c8f-a4c6-c4920feca14e	2025-12-29 14:04:59.02137+00	4c52122a-4587-4e5f-9671-520ffc530de7
e186215f-2464-4584-980e-36ec5ebe0285	12000	c51550f9-febf-40f9-81b0-ec9fd0570d11	2025-12-29 14:04:59.02137+00	b9186c6a-497a-41b2-a4e2-e456bf8ed725
206f74d7-d74d-4066-8cb9-5e22e8705017	4000	9e29d3f7-b2c7-4c2c-b0d9-6a2df493e331	2025-12-29 14:04:59.02137+00	042a9a56-7188-4367-9b59-9cd1ca25fc55
206f74d7-d74d-4066-8cb9-5e22e8705017	6000	0bcbe064-9b6d-4aad-a744-6bde9003168c	2025-12-29 14:04:59.02137+00	4c52122a-4587-4e5f-9671-520ffc530de7
206f74d7-d74d-4066-8cb9-5e22e8705017	8000	8cbbdcc4-11b1-4d4d-863d-de40259890d7	2025-12-29 14:04:59.02137+00	b9186c6a-497a-41b2-a4e2-e456bf8ed725
cb681add-b95a-463f-9315-ab6bf98b3645	20000	2c904d03-feef-435d-aada-436a5b3203ea	2025-12-29 14:04:59.02137+00	042a9a56-7188-4367-9b59-9cd1ca25fc55
cb681add-b95a-463f-9315-ab6bf98b3645	25000	957d59d8-d15a-4c1c-9d8f-29c5d8422439	2025-12-29 14:04:59.02137+00	4c52122a-4587-4e5f-9671-520ffc530de7
cb681add-b95a-463f-9315-ab6bf98b3645	30000	804cf9d0-2783-4a31-bb5d-f55b39880d4f	2025-12-29 14:04:59.02137+00	b9186c6a-497a-41b2-a4e2-e456bf8ed725
0c4ac855-502f-47b3-9142-d8eb6bc38f4f	30000	addd049e-b515-45b5-9a90-3ecbb0908935	2025-12-29 14:04:59.02137+00	042a9a56-7188-4367-9b59-9cd1ca25fc55
0c4ac855-502f-47b3-9142-d8eb6bc38f4f	20000	7bad6ec9-2d48-48a7-b08a-f379c9a076d9	2025-12-29 14:04:59.02137+00	4c52122a-4587-4e5f-9671-520ffc530de7
0c4ac855-502f-47b3-9142-d8eb6bc38f4f	10000	620d1ed4-c5f3-4b29-b459-859be05edab4	2025-12-29 14:04:59.02137+00	b9186c6a-497a-41b2-a4e2-e456bf8ed725
e1fb49d3-b6fd-43c7-b2fd-45fc6a6300a4	5000	889c955f-da0f-45b5-a0ba-fd19877cef04	2025-12-29 14:04:59.02137+00	042a9a56-7188-4367-9b59-9cd1ca25fc55
e1fb49d3-b6fd-43c7-b2fd-45fc6a6300a4	10000	b2282951-bbd3-4a02-9c96-c53aa7619076	2025-12-29 14:04:59.02137+00	4c52122a-4587-4e5f-9671-520ffc530de7
e1fb49d3-b6fd-43c7-b2fd-45fc6a6300a4	15000	c713dd12-3aaa-41a3-91ea-78c4ca3a8a6d	2025-12-29 14:04:59.02137+00	b9186c6a-497a-41b2-a4e2-e456bf8ed725
2f6eb472-ed2b-4034-9205-44cebc090a97	5000	69e12fb1-317a-4af9-bdf9-c55675f68dc8	2025-12-29 14:04:59.02137+00	042a9a56-7188-4367-9b59-9cd1ca25fc55
2f6eb472-ed2b-4034-9205-44cebc090a97	10000	cb8f1835-cd3b-47df-96dd-e6a82b11b346	2025-12-29 14:04:59.02137+00	4c52122a-4587-4e5f-9671-520ffc530de7
2f6eb472-ed2b-4034-9205-44cebc090a97	15000	7b77b552-9f0d-4ed2-8074-c50b797528c3	2025-12-29 14:04:59.02137+00	b9186c6a-497a-41b2-a4e2-e456bf8ed725
0a21ddea-5b70-4b81-9993-39d5edff4327	6000	d200045e-4082-451c-afc6-dac623273ee4	2026-02-21 07:39:47.200396+00	981e7f2e-04b2-410a-a724-3311924abeb7
0a21ddea-5b70-4b81-9993-39d5edff4327	8000	6d6b5e92-92aa-4dba-a74a-ab427085d9f2	2026-02-21 07:39:47.200396+00	4b8257b7-e364-44c4-806a-c462d9412656
0a21ddea-5b70-4b81-9993-39d5edff4327	12000	097dfc65-8fd6-455b-9986-93022a16eae7	2026-02-21 07:39:47.200396+00	d7a147d9-f6e8-4ca3-979d-f2bc83da03f2
0d35a926-2327-40d8-bc28-6ed427c54eda	4000	76a18fc5-0bd6-400e-85da-fff7a1d3d9ce	2026-02-21 07:39:47.200396+00	981e7f2e-04b2-410a-a724-3311924abeb7
0d35a926-2327-40d8-bc28-6ed427c54eda	6000	576c61c9-6c93-4396-ad19-206c65a862d2	2026-02-21 07:39:47.200396+00	4b8257b7-e364-44c4-806a-c462d9412656
0d35a926-2327-40d8-bc28-6ed427c54eda	8000	95957a86-e1c6-4a72-91f1-a9718d474428	2026-02-21 07:39:47.200396+00	d7a147d9-f6e8-4ca3-979d-f2bc83da03f2
4f588eab-510c-4e93-aa51-2f80029f5f99	20000	a7b8283f-00e0-4bc9-bca2-8b960800cc00	2026-02-21 07:39:47.200396+00	981e7f2e-04b2-410a-a724-3311924abeb7
4f588eab-510c-4e93-aa51-2f80029f5f99	25000	115acf22-a49e-4c96-8151-e87003a1ad4c	2026-02-21 07:39:47.200396+00	4b8257b7-e364-44c4-806a-c462d9412656
4f588eab-510c-4e93-aa51-2f80029f5f99	30000	77378fc8-39e0-4258-a62d-ea7d04198be7	2026-02-21 07:39:47.200396+00	d7a147d9-f6e8-4ca3-979d-f2bc83da03f2
0478b2cd-187a-4931-9cda-c9d66ead2162	30000	d5baa8b2-391c-499f-8aa3-50d56c1206e2	2026-02-21 07:39:47.200396+00	981e7f2e-04b2-410a-a724-3311924abeb7
0478b2cd-187a-4931-9cda-c9d66ead2162	20000	fe4e802a-e210-4de6-b92c-f98f1f7bcd7f	2026-02-21 07:39:47.200396+00	4b8257b7-e364-44c4-806a-c462d9412656
0478b2cd-187a-4931-9cda-c9d66ead2162	10000	df5885d1-1a16-449a-8e07-40a8f28490af	2026-02-21 07:39:47.200396+00	d7a147d9-f6e8-4ca3-979d-f2bc83da03f2
d8ea9db0-204e-4d55-a402-f14c0bae94eb	5000	3f697e04-71b3-4c5b-a940-8a80bf75fcc5	2026-02-21 07:39:47.200396+00	981e7f2e-04b2-410a-a724-3311924abeb7
d8ea9db0-204e-4d55-a402-f14c0bae94eb	10000	af43f70e-dc36-4959-a16c-d9d7da970223	2026-02-21 07:39:47.200396+00	4b8257b7-e364-44c4-806a-c462d9412656
d8ea9db0-204e-4d55-a402-f14c0bae94eb	15000	b05647b1-b885-4c5d-a788-328c421eb05b	2026-02-21 07:39:47.200396+00	d7a147d9-f6e8-4ca3-979d-f2bc83da03f2
da8e65b0-2e18-43dc-8e34-b2e6ab1215ea	5000	4c195adf-659c-4293-b09c-d04dd19a87e7	2026-02-21 07:39:47.200396+00	981e7f2e-04b2-410a-a724-3311924abeb7
da8e65b0-2e18-43dc-8e34-b2e6ab1215ea	10000	28e734b2-314e-461c-9792-c12822b4e2fa	2026-02-21 07:39:47.200396+00	4b8257b7-e364-44c4-806a-c462d9412656
da8e65b0-2e18-43dc-8e34-b2e6ab1215ea	15000	4dcd473e-9002-420b-9b2d-6b7c39c63a00	2026-02-21 07:39:47.200396+00	d7a147d9-f6e8-4ca3-979d-f2bc83da03f2
f23f59b2-25bf-43f2-9bfa-f483dbfbf1de	6000	bb21903f-a8c8-4c3b-a390-cda9fe46edd6	2026-02-21 07:40:46.243271+00	afc942c2-4267-4e8e-bd9d-9ef94318e690
f23f59b2-25bf-43f2-9bfa-f483dbfbf1de	8000	ca918d40-1e57-4c0e-b490-40ba3bfa1666	2026-02-21 07:40:46.243271+00	2c125ada-d5ac-46d2-a0ae-0692f3614dbe
f23f59b2-25bf-43f2-9bfa-f483dbfbf1de	12000	f5882dd8-3c96-4434-b835-f72f646625cf	2026-02-21 07:40:46.243271+00	b254fa16-6a50-47a8-8541-89b74e743510
6ac26169-078e-41a3-b6f2-bb428678c97c	4000	18d48cfe-3110-40c8-bfc0-4f884d57b095	2026-02-21 07:40:46.243271+00	afc942c2-4267-4e8e-bd9d-9ef94318e690
6ac26169-078e-41a3-b6f2-bb428678c97c	6000	0506ec45-afc0-4d4a-9dd8-26d8efa513e2	2026-02-21 07:40:46.243271+00	2c125ada-d5ac-46d2-a0ae-0692f3614dbe
6ac26169-078e-41a3-b6f2-bb428678c97c	8000	1a7e7620-072a-45fa-9fc4-93aaa2cd1641	2026-02-21 07:40:46.243271+00	b254fa16-6a50-47a8-8541-89b74e743510
5309f142-929c-4fe3-8404-1e5413d3210d	20000	ed0b71b8-5ce5-443b-bd67-526539ea5b2e	2026-02-21 07:40:46.243271+00	afc942c2-4267-4e8e-bd9d-9ef94318e690
5309f142-929c-4fe3-8404-1e5413d3210d	25000	b7572d65-118a-4f01-bfd6-5e923409afce	2026-02-21 07:40:46.243271+00	2c125ada-d5ac-46d2-a0ae-0692f3614dbe
5309f142-929c-4fe3-8404-1e5413d3210d	30000	84ed2b13-9d4e-46eb-bcc7-3a3331a0122e	2026-02-21 07:40:46.243271+00	b254fa16-6a50-47a8-8541-89b74e743510
a0f1fb0d-06ea-4fb9-b7cd-59e2a95997a0	30000	0bba5844-f36c-4f58-b559-c63315715476	2026-02-21 07:40:46.243271+00	afc942c2-4267-4e8e-bd9d-9ef94318e690
a0f1fb0d-06ea-4fb9-b7cd-59e2a95997a0	20000	50b27eba-5f68-40f0-bd91-a539d7abc839	2026-02-21 07:40:46.243271+00	2c125ada-d5ac-46d2-a0ae-0692f3614dbe
a0f1fb0d-06ea-4fb9-b7cd-59e2a95997a0	10000	278003e7-7b25-49ea-b920-f3d41140ea67	2026-02-21 07:40:46.243271+00	b254fa16-6a50-47a8-8541-89b74e743510
0265da5f-7294-4feb-a951-d5e23d352f57	5000	8816889f-4051-4aa4-ad9e-d466c72f2c55	2026-02-21 07:40:46.243271+00	afc942c2-4267-4e8e-bd9d-9ef94318e690
0265da5f-7294-4feb-a951-d5e23d352f57	10000	f0b1b1df-ba78-4c08-afdb-e128d02d12a2	2026-02-21 07:40:46.243271+00	2c125ada-d5ac-46d2-a0ae-0692f3614dbe
0265da5f-7294-4feb-a951-d5e23d352f57	15000	23d879f1-bf1d-4193-9bfc-184609663afe	2026-02-21 07:40:46.243271+00	b254fa16-6a50-47a8-8541-89b74e743510
28bd00f7-b0aa-490c-ab9d-11515cf8104d	5000	09c6f9da-5b3d-4710-b05d-fd9f7f10c0c0	2026-02-21 07:40:46.243271+00	afc942c2-4267-4e8e-bd9d-9ef94318e690
28bd00f7-b0aa-490c-ab9d-11515cf8104d	10000	b1d4c0c3-fc9a-4de6-b191-043be1f511bc	2026-02-21 07:40:46.243271+00	2c125ada-d5ac-46d2-a0ae-0692f3614dbe
28bd00f7-b0aa-490c-ab9d-11515cf8104d	15000	e7c5fe94-0511-461f-a820-5167060592b5	2026-02-21 07:40:46.243271+00	b254fa16-6a50-47a8-8541-89b74e743510
d127049b-14b8-4434-b01d-118818a8d59e	6000	ce0d8d6a-abee-41a4-a2cc-9e39f9717a25	2026-02-21 07:41:12.842216+00	361d4ddd-5fa5-48bb-93f8-b2c961c499a6
d127049b-14b8-4434-b01d-118818a8d59e	8000	f7cc680c-3f23-42ec-8642-281c762f0180	2026-02-21 07:41:12.842216+00	a1aec9c7-f06f-47c5-a6ae-f7e94fdf60bf
d127049b-14b8-4434-b01d-118818a8d59e	12000	341dd1d1-bc8b-4b4e-833b-4929c294ed53	2026-02-21 07:41:12.842216+00	9fd5d020-98ef-413c-84f0-d9a7f50cf611
1d338adc-9887-4bb3-9575-2efbeb690343	4000	db3ca927-f35f-4882-b666-6842cde4225b	2026-02-21 07:41:12.842216+00	361d4ddd-5fa5-48bb-93f8-b2c961c499a6
1d338adc-9887-4bb3-9575-2efbeb690343	6000	27ea9832-8c2c-4c53-b886-b85d4bc51432	2026-02-21 07:41:12.842216+00	a1aec9c7-f06f-47c5-a6ae-f7e94fdf60bf
1d338adc-9887-4bb3-9575-2efbeb690343	8000	6ea38c25-f1bd-454f-b4bd-aec37d08e6a6	2026-02-21 07:41:12.842216+00	9fd5d020-98ef-413c-84f0-d9a7f50cf611
b3751879-3a47-4c55-85b3-fd99778ab133	20000	4d011ef3-e2d0-4306-bc3b-a5804c6d7686	2026-02-21 07:41:12.842216+00	361d4ddd-5fa5-48bb-93f8-b2c961c499a6
b3751879-3a47-4c55-85b3-fd99778ab133	25000	d05adeef-0968-4998-ba88-64883173c530	2026-02-21 07:41:12.842216+00	a1aec9c7-f06f-47c5-a6ae-f7e94fdf60bf
b3751879-3a47-4c55-85b3-fd99778ab133	30000	8312a26d-b153-4a7c-810c-3598166458f2	2026-02-21 07:41:12.842216+00	9fd5d020-98ef-413c-84f0-d9a7f50cf611
4059fbec-6a42-4b78-b03c-7f06d541ffb5	30000	5adf0ff1-8850-4b42-ad18-ebc6b1cde76e	2026-02-21 07:41:12.842216+00	361d4ddd-5fa5-48bb-93f8-b2c961c499a6
4059fbec-6a42-4b78-b03c-7f06d541ffb5	20000	f06a6868-a789-4f69-ba76-f487df55a0c5	2026-02-21 07:41:12.842216+00	a1aec9c7-f06f-47c5-a6ae-f7e94fdf60bf
4059fbec-6a42-4b78-b03c-7f06d541ffb5	10000	f888c77a-37b3-4fb0-904e-6a8b28e80f0b	2026-02-21 07:41:12.842216+00	9fd5d020-98ef-413c-84f0-d9a7f50cf611
397cd58f-cc3f-4975-9172-61e9b92a54b8	5000	e55e1996-40aa-47a3-9cea-a9fdc86d569c	2026-02-21 07:41:12.842216+00	361d4ddd-5fa5-48bb-93f8-b2c961c499a6
397cd58f-cc3f-4975-9172-61e9b92a54b8	10000	ea7e6dc0-775b-4131-a443-9f0e5a1f809f	2026-02-21 07:41:12.842216+00	a1aec9c7-f06f-47c5-a6ae-f7e94fdf60bf
397cd58f-cc3f-4975-9172-61e9b92a54b8	15000	5c1b9263-c289-4b80-b72f-b7b212557f48	2026-02-21 07:41:12.842216+00	9fd5d020-98ef-413c-84f0-d9a7f50cf611
b54b506a-2bdb-4af1-9750-f53c00d6b417	5000	cd1d315d-f6a2-4f40-aaa1-049eafeba239	2026-02-21 07:41:12.842216+00	361d4ddd-5fa5-48bb-93f8-b2c961c499a6
b54b506a-2bdb-4af1-9750-f53c00d6b417	10000	aab9d71e-3f73-47c7-9aff-1e1a26efd581	2026-02-21 07:41:12.842216+00	a1aec9c7-f06f-47c5-a6ae-f7e94fdf60bf
b54b506a-2bdb-4af1-9750-f53c00d6b417	15000	50db48da-ae26-44ba-8600-3a0010aa8cd5	2026-02-21 07:41:12.842216+00	9fd5d020-98ef-413c-84f0-d9a7f50cf611
77c5e880-423f-4f2a-af97-36bc9902b934	6000	9a929bac-9ce4-443e-a9ab-83b8c403bc32	2026-02-21 07:41:28.499124+00	ff9c402f-c5ee-4a69-a02b-248cf1f0e89a
77c5e880-423f-4f2a-af97-36bc9902b934	8000	d86c7ce4-e3c2-4e36-a3a4-6c30d94759b4	2026-02-21 07:41:28.499124+00	238cf216-0a1e-4f8f-8897-a5aa0d8f45c9
77c5e880-423f-4f2a-af97-36bc9902b934	12000	b4b7cc16-5472-4ef9-95e9-d414eb75edec	2026-02-21 07:41:28.499124+00	a572230f-4f02-4842-9d9e-0fc60ae77323
68bbafc7-3045-4326-886a-406532847e9b	4000	03402ade-f08a-4d0b-a29c-8fa2881affb5	2026-02-21 07:41:28.499124+00	ff9c402f-c5ee-4a69-a02b-248cf1f0e89a
68bbafc7-3045-4326-886a-406532847e9b	6000	d2a1e66c-4bda-45eb-b30b-c10d71541d3d	2026-02-21 07:41:28.499124+00	238cf216-0a1e-4f8f-8897-a5aa0d8f45c9
68bbafc7-3045-4326-886a-406532847e9b	8000	6d7c3836-15c6-41fa-909a-ff6625041b28	2026-02-21 07:41:28.499124+00	a572230f-4f02-4842-9d9e-0fc60ae77323
7e7b8dbc-fc61-4c20-a34c-a8df21f9d2b2	20000	0babe6c1-bbb4-43ad-8975-a359c5299698	2026-02-21 07:41:28.499124+00	ff9c402f-c5ee-4a69-a02b-248cf1f0e89a
7e7b8dbc-fc61-4c20-a34c-a8df21f9d2b2	25000	aa5c54e0-80e7-4d2c-b236-620d7fda5ed5	2026-02-21 07:41:28.499124+00	238cf216-0a1e-4f8f-8897-a5aa0d8f45c9
7e7b8dbc-fc61-4c20-a34c-a8df21f9d2b2	30000	bd312702-932a-4d7a-9dd5-9bf4fa97adf1	2026-02-21 07:41:28.499124+00	a572230f-4f02-4842-9d9e-0fc60ae77323
a73b5fab-4dfa-485c-8cb6-c1c3f7a714bc	30000	af770f5f-7238-4225-a9e7-4ac01239d5d3	2026-02-21 07:41:28.499124+00	ff9c402f-c5ee-4a69-a02b-248cf1f0e89a
a73b5fab-4dfa-485c-8cb6-c1c3f7a714bc	20000	0614c076-8e7b-4944-bdca-225bc518d143	2026-02-21 07:41:28.499124+00	238cf216-0a1e-4f8f-8897-a5aa0d8f45c9
a73b5fab-4dfa-485c-8cb6-c1c3f7a714bc	10000	d2f3792b-4587-4c3f-be6c-2b5900c8adbb	2026-02-21 07:41:28.499124+00	a572230f-4f02-4842-9d9e-0fc60ae77323
89897de9-347f-40b5-8623-0e06ec7d05d7	5000	5080014c-2d6f-4316-b57a-605239db1a5d	2026-02-21 07:41:28.499124+00	ff9c402f-c5ee-4a69-a02b-248cf1f0e89a
89897de9-347f-40b5-8623-0e06ec7d05d7	10000	e1526af1-be8b-4f69-8564-979a418cc64c	2026-02-21 07:41:28.499124+00	238cf216-0a1e-4f8f-8897-a5aa0d8f45c9
89897de9-347f-40b5-8623-0e06ec7d05d7	15000	0ff8a20f-20d8-4925-9262-6776ad40b4d1	2026-02-21 07:41:28.499124+00	a572230f-4f02-4842-9d9e-0fc60ae77323
5993cd2a-3f27-4e9c-b9cb-a6094ea53095	5000	026c971f-6d8e-421e-9737-8eaf67c24c9e	2026-02-21 07:41:28.499124+00	ff9c402f-c5ee-4a69-a02b-248cf1f0e89a
5993cd2a-3f27-4e9c-b9cb-a6094ea53095	10000	813ae917-d4d2-4d50-9c5e-2b1002dd674a	2026-02-21 07:41:28.499124+00	238cf216-0a1e-4f8f-8897-a5aa0d8f45c9
5993cd2a-3f27-4e9c-b9cb-a6094ea53095	15000	1bb21b73-e1f4-43de-9a12-d6741ab1a859	2026-02-21 07:41:28.499124+00	a572230f-4f02-4842-9d9e-0fc60ae77323
4af2b638-8c6c-4a20-9340-d9be3bffa6e9	6000	17aa69d1-6766-4dfe-9f64-9858f0d3ee58	2026-02-22 12:46:24.072509+00	03851633-508b-45e9-84da-e9efba545cf7
4af2b638-8c6c-4a20-9340-d9be3bffa6e9	8000	f94bad7e-a29f-443d-8606-d68738908424	2026-02-22 12:46:24.072509+00	87966686-2950-42a4-af9a-4bad571ae99e
4af2b638-8c6c-4a20-9340-d9be3bffa6e9	12000	fcf5f312-ea0c-4c23-8d9a-1ab3584703ec	2026-02-22 12:46:24.072509+00	f282fceb-30f0-4425-813c-5cf5154a8cad
ca1053f7-2c33-407b-b4db-31843d37d59e	4000	915e1c11-a88b-4917-aa53-41a2ef92ba2a	2026-02-22 12:46:24.072509+00	03851633-508b-45e9-84da-e9efba545cf7
ca1053f7-2c33-407b-b4db-31843d37d59e	6000	a8f7d71a-989d-4aad-9cb7-05b1c8e3214f	2026-02-22 12:46:24.072509+00	87966686-2950-42a4-af9a-4bad571ae99e
ca1053f7-2c33-407b-b4db-31843d37d59e	8000	3dbd97f2-bbdd-424f-9050-2302d90e23a6	2026-02-22 12:46:24.072509+00	f282fceb-30f0-4425-813c-5cf5154a8cad
c8f58f97-2ad0-4123-8859-ff2c8bbd0912	20000	4c9f8be1-5dd8-491a-8103-af8abcf2d6b1	2026-02-22 12:46:24.072509+00	03851633-508b-45e9-84da-e9efba545cf7
c8f58f97-2ad0-4123-8859-ff2c8bbd0912	25000	628f0983-7016-44db-a256-47441971f57c	2026-02-22 12:46:24.072509+00	87966686-2950-42a4-af9a-4bad571ae99e
c8f58f97-2ad0-4123-8859-ff2c8bbd0912	30000	4f4b4385-29ff-4dfe-b68b-ee3762f91453	2026-02-22 12:46:24.072509+00	f282fceb-30f0-4425-813c-5cf5154a8cad
718520bf-40cf-4e9e-8b5a-9e2ca5bb9231	30000	ef230f29-184a-48af-889c-4f072b162830	2026-02-22 12:46:24.072509+00	03851633-508b-45e9-84da-e9efba545cf7
718520bf-40cf-4e9e-8b5a-9e2ca5bb9231	20000	22369c34-dde6-4e90-ade4-fec2160bf597	2026-02-22 12:46:24.072509+00	87966686-2950-42a4-af9a-4bad571ae99e
718520bf-40cf-4e9e-8b5a-9e2ca5bb9231	10000	1de5091a-ced8-416b-b90c-26eb14b70032	2026-02-22 12:46:24.072509+00	f282fceb-30f0-4425-813c-5cf5154a8cad
1f5a9647-72ec-4a15-a464-489e935318e6	5000	0a037aee-ccca-4948-bdb7-3a0df9b9213b	2026-02-22 12:46:24.072509+00	03851633-508b-45e9-84da-e9efba545cf7
1f5a9647-72ec-4a15-a464-489e935318e6	10000	3af1fc60-fa1a-4c25-8724-310e598f83a7	2026-02-22 12:46:24.072509+00	87966686-2950-42a4-af9a-4bad571ae99e
1f5a9647-72ec-4a15-a464-489e935318e6	15000	7be68cde-2733-4fec-9de6-db34ed1a5df4	2026-02-22 12:46:24.072509+00	f282fceb-30f0-4425-813c-5cf5154a8cad
9a3df121-8c9c-4661-ae1a-340cb170f621	5000	d6e9743f-5ca1-433e-b8e8-09a91876e64f	2026-02-22 12:46:24.072509+00	03851633-508b-45e9-84da-e9efba545cf7
9a3df121-8c9c-4661-ae1a-340cb170f621	10000	d7eb4409-fe8d-47c6-824f-86d6456453ed	2026-02-22 12:46:24.072509+00	87966686-2950-42a4-af9a-4bad571ae99e
9a3df121-8c9c-4661-ae1a-340cb170f621	15000	f7e794f6-72d3-4b83-8175-c5fd8b5ca653	2026-02-22 12:46:24.072509+00	f282fceb-30f0-4425-813c-5cf5154a8cad
ea54276c-3bb3-4c7e-9dc8-8250222d8cf0	6000	fb3da30a-3c86-47e0-87b2-8eec5b32f9c8	2026-02-27 22:29:07.835999+00	af3c79e4-2b9d-4ea8-a86a-8861fd55dcf0
ea54276c-3bb3-4c7e-9dc8-8250222d8cf0	8000	a6e5ec60-84d1-4a8c-a28a-75463d36c3d5	2026-02-27 22:29:07.835999+00	25514e6f-69be-4143-aa4c-20baef759bf4
ea54276c-3bb3-4c7e-9dc8-8250222d8cf0	12000	9964b718-ee56-4223-86ab-ae65de47e5c5	2026-02-27 22:29:07.835999+00	0ff0dd0a-03fd-4110-87fc-a14f44ca876d
3a2e7316-aba0-4e03-87ce-62d303fc3337	4000	ead20d42-c254-4258-a2f8-b845e94520a3	2026-02-27 22:29:07.835999+00	af3c79e4-2b9d-4ea8-a86a-8861fd55dcf0
3a2e7316-aba0-4e03-87ce-62d303fc3337	6000	4a491dde-f9b1-4180-b09f-4318cc9ca83a	2026-02-27 22:29:07.835999+00	25514e6f-69be-4143-aa4c-20baef759bf4
3a2e7316-aba0-4e03-87ce-62d303fc3337	8000	707682b7-e12e-4261-990d-cfdf8fcd71b7	2026-02-27 22:29:07.835999+00	0ff0dd0a-03fd-4110-87fc-a14f44ca876d
01d0732a-21dd-4a6e-84a8-a927949ea2e9	20000	30720f83-8d8f-46ba-b9ff-9aae7be63c81	2026-02-27 22:29:07.835999+00	af3c79e4-2b9d-4ea8-a86a-8861fd55dcf0
01d0732a-21dd-4a6e-84a8-a927949ea2e9	25000	c54f3167-d13e-4ccb-a1a1-339de235d6f0	2026-02-27 22:29:07.835999+00	25514e6f-69be-4143-aa4c-20baef759bf4
01d0732a-21dd-4a6e-84a8-a927949ea2e9	30000	d1a4aa83-2123-46eb-b889-9414868289ba	2026-02-27 22:29:07.835999+00	0ff0dd0a-03fd-4110-87fc-a14f44ca876d
1a34658f-5391-4820-a6d3-0aec6d869f94	30000	d2e3e007-4980-4640-8976-6f680319a235	2026-02-27 22:29:07.835999+00	af3c79e4-2b9d-4ea8-a86a-8861fd55dcf0
1a34658f-5391-4820-a6d3-0aec6d869f94	20000	01a2d0f0-c078-4e90-bdb8-3effae9e3493	2026-02-27 22:29:07.835999+00	25514e6f-69be-4143-aa4c-20baef759bf4
1a34658f-5391-4820-a6d3-0aec6d869f94	10000	05f9c520-08f1-4bce-91ae-1c7a696aa08b	2026-02-27 22:29:07.835999+00	0ff0dd0a-03fd-4110-87fc-a14f44ca876d
24e92d13-4c36-4f43-80e8-595cea91670f	5000	38b62c5b-0ddf-4420-91af-5d46d0f0536a	2026-02-27 22:29:07.835999+00	af3c79e4-2b9d-4ea8-a86a-8861fd55dcf0
24e92d13-4c36-4f43-80e8-595cea91670f	10000	0d4211fe-250e-4425-9842-821e6eb409cd	2026-02-27 22:29:07.835999+00	25514e6f-69be-4143-aa4c-20baef759bf4
24e92d13-4c36-4f43-80e8-595cea91670f	15000	2884467e-b575-4d81-a72f-d1b52cf02dc2	2026-02-27 22:29:07.835999+00	0ff0dd0a-03fd-4110-87fc-a14f44ca876d
b5532d4b-3b4e-4a47-9199-300c25b3d5b0	5000	5de13441-ea16-499e-86d4-6f7951d0c7fe	2026-02-27 22:29:07.835999+00	af3c79e4-2b9d-4ea8-a86a-8861fd55dcf0
b5532d4b-3b4e-4a47-9199-300c25b3d5b0	10000	6ab2f271-9072-48b2-a86f-483664351ba1	2026-02-27 22:29:07.835999+00	25514e6f-69be-4143-aa4c-20baef759bf4
b5532d4b-3b4e-4a47-9199-300c25b3d5b0	15000	7aeadfde-bcb3-4628-85dc-d62c81ac23c5	2026-02-27 22:29:07.835999+00	0ff0dd0a-03fd-4110-87fc-a14f44ca876d
\.


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transaction (id, created_at, customer_id, completed_at, ready_to_pick_up_at, merchant_id, customer_name, customer_address, status, customer_email, customer_phone_number, "order", note, deleted_at, discount_id, discount_amount) FROM stdin;
e217fe0b-36c3-4264-a1c5-d2d2697891cd	2025-10-10 13:13:27.963657+00	d8230d29-a0d5-4030-b25a-0b558cad0e9c	2025-10-10 13:21:33.383584	\N	8db3f967-5f09-4150-a95b-010faa31a22a	test		Selesai	\N	8546488948	1	\N	\N	\N	0
75d8ba9c-1ad5-4970-afd4-e001cfddd1b0	2025-10-17 13:36:01.714874+00	a71adc7f-f1ff-4ef3-a2f5-d186d082adc3	\N	2025-11-10 21:17:22.819387	8db3f967-5f09-4150-a95b-010faa31a22a	ghshshshj		Siap Diambil	\N	8542266884	7		\N	\N	0
f4d3a0ab-1f3e-425f-96fd-e4cc6217950f	2025-10-10 13:21:53.509243+00	d8230d29-a0d5-4030-b25a-0b558cad0e9c	\N	2025-10-19 04:40:51.474199	8db3f967-5f09-4150-a95b-010faa31a22a	test		Siap Diambil	\N	8546488948	2	\N	\N	\N	0
2ca8ad49-b3b9-4a01-8285-9883f34df992	2025-10-17 13:36:30.898999+00	a71adc7f-f1ff-4ef3-a2f5-d186d082adc3	\N	2025-11-10 21:17:34.216959	8db3f967-5f09-4150-a95b-010faa31a22a	ghshshshj		Siap Diambil	\N	8542266884	8		\N	\N	0
ffd03e9e-c787-40ad-afa1-4dd490b40e80	2025-10-17 13:28:27.375117+00	7fd4bb2d-8ece-4197-ba9b-63144011b10d	\N	2025-10-19 04:45:25.118033	8db3f967-5f09-4150-a95b-010faa31a22a	dksdskjd		Siap Diambil	\N	08329283384	4		\N	\N	0
1b12893c-f23d-4c62-9f47-f498904fb0db	2025-10-17 13:37:16.88089+00	b0f3c299-02f9-440a-ac51-a1615bc35695	\N	2025-11-10 21:17:56.506729	8db3f967-5f09-4150-a95b-010faa31a22a	diyaca8650		Siap Diambil	\N	085767888888	9		\N	\N	0
c21b4e83-45e8-4ce9-8ff9-1abc78b5dd20	2025-10-18 22:24:22.422401+00	7fd4bb2d-8ece-4197-ba9b-63144011b10d	2025-10-19 05:00:38.28523	2025-10-19 04:58:54.066416	8db3f967-5f09-4150-a95b-010faa31a22a	dksdskjd		Selesai	\N	08329283384	24		\N	\N	0
90b7cb1b-c809-4372-9c5c-ddca831b7a51	2025-10-17 13:35:16.771182+00	a71adc7f-f1ff-4ef3-a2f5-d186d082adc3	\N	2025-10-19 05:37:29.802748	8db3f967-5f09-4150-a95b-010faa31a22a	ghshshshj		Siap Diambil	\N	8542266884	6		\N	\N	0
30575655-aa99-482f-be0b-637da76e3e62	2025-10-19 12:32:39.463617+00	b65e3685-90b2-4835-a18c-46619ec5f279	2025-10-19 12:35:55.996917	2025-10-19 12:35:48.895382	8db3f967-5f09-4150-a95b-010faa31a22a	sijon	Jalan	Selesai	\N	85664221560	25	Kkkkkk	\N	\N	0
d64225d9-4684-4f07-9f6e-1f4dfacdfb07	2025-10-17 21:50:24.896161+00	b65e3685-90b2-4835-a18c-46619ec5f279	2025-10-19 12:37:59.259977	2025-10-19 04:47:36.012497	8db3f967-5f09-4150-a95b-010faa31a22a	sijon	Jalan	Selesai	\N	85664221560	23	Bbbbhj+hhhhh-hhhhh	\N	\N	0
e09d4a5e-a4cc-44de-b20f-844ca4766821	2025-10-11 08:26:38.204975+00	d8230d29-a0d5-4030-b25a-0b558cad0e9c	2025-10-19 12:38:32.813429	2025-10-19 04:41:07.737323	8db3f967-5f09-4150-a95b-010faa31a22a	test		Selesai	\N	8546488948	3	\N	\N	\N	0
8a3b8432-8441-4e57-bef4-89be1dd0f578	2025-10-17 13:31:36.592731+00	b65e3685-90b2-4835-a18c-46619ec5f279	\N	2025-11-10 21:16:59.771454	8db3f967-5f09-4150-a95b-010faa31a22a	sijon	Jalan	Siap Diambil	\N	85664221560	5		\N	\N	0
9afc00ea-4b0b-4c69-a2c2-1c970401fef9	2025-10-17 13:39:17.282101+00	4fcc1210-b3c5-4f59-b293-e652e71d3ff5	\N	2025-12-08 12:23:21.320597	8db3f967-5f09-4150-a95b-010faa31a22a	jjhjhkii		Siap Diambil	\N	08246565776	10		\N	\N	0
5dde48c9-9352-4213-a5f2-e7e059fc435d	2025-10-17 13:39:56.062147+00	4fcc1210-b3c5-4f59-b293-e652e71d3ff5	\N	2025-12-08 12:23:39.978138	8db3f967-5f09-4150-a95b-010faa31a22a	jjhjhkii		Siap Diambil	\N	08246565776	11		\N	\N	0
c79e4d4d-366f-45ef-8e80-f6c8683ac8ea	2025-10-17 13:40:33.016088+00	4fcc1210-b3c5-4f59-b293-e652e71d3ff5	\N	2025-12-08 12:23:52.726203	8db3f967-5f09-4150-a95b-010faa31a22a	jjhjhkii		Siap Diambil	\N	08246565776	12		\N	\N	0
e6a8eb85-1539-483d-9c79-cdf95b4f36af	2025-10-17 13:42:24.155901+00	4fcc1210-b3c5-4f59-b293-e652e71d3ff5	\N	2025-12-08 12:24:01.219913	8db3f967-5f09-4150-a95b-010faa31a22a	jjhjhkii		Siap Diambil	\N	08246565776	13		\N	\N	0
8ac553fc-d111-487d-96bf-c14e2447d128	2025-10-17 13:42:56.27378+00	4fcc1210-b3c5-4f59-b293-e652e71d3ff5	\N	2025-12-08 12:24:40.198933	8db3f967-5f09-4150-a95b-010faa31a22a	jjhjhkii		Siap Diambil	\N	08246565776	14		\N	\N	0
5f6b6df0-53ef-4ac2-ba36-ee36dee6e901	2025-10-17 13:43:24.591355+00	4fcc1210-b3c5-4f59-b293-e652e71d3ff5	\N	2025-12-08 12:24:48.315826	8db3f967-5f09-4150-a95b-010faa31a22a	jjhjhkii		Siap Diambil	\N	08246565776	15		\N	\N	0
f522e287-fb13-41a2-8bbf-63d76ffbc006	2025-10-17 13:52:26.037431+00	4fcc1210-b3c5-4f59-b293-e652e71d3ff5	\N	2025-12-08 12:24:56.91682	8db3f967-5f09-4150-a95b-010faa31a22a	jjhjhkii		Siap Diambil	\N	08246565776	16		\N	\N	0
6083db98-a0de-4f5f-aed0-48bc034fb8f8	2025-10-17 13:55:52.502156+00	4fcc1210-b3c5-4f59-b293-e652e71d3ff5	\N	2025-12-08 12:25:07.828587	8db3f967-5f09-4150-a95b-010faa31a22a	jjhjhkii		Siap Diambil	\N	08246565776	17		\N	\N	0
11d0a36c-a55b-42a2-a523-8da140667f5a	2025-10-17 13:58:51.332768+00	b65e3685-90b2-4835-a18c-46619ec5f279	\N	2025-12-08 12:25:17.589061	8db3f967-5f09-4150-a95b-010faa31a22a	sijon	Jalan	Siap Diambil	\N	85664221560	18		\N	\N	0
3b246b84-8bd2-4fa5-9f31-d77eeec50808	2025-10-17 21:31:35.186582+00	b65e3685-90b2-4835-a18c-46619ec5f279	\N	2025-12-08 12:25:29.384124	8db3f967-5f09-4150-a95b-010faa31a22a	sijon	Jalan	Siap Diambil	\N	85664221560	19		\N	\N	0
54d871be-87d5-4675-acf1-c67e1b7387a5	2025-10-17 21:36:56.853014+00	b65e3685-90b2-4835-a18c-46619ec5f279	\N	2025-12-08 12:25:52.699803	8db3f967-5f09-4150-a95b-010faa31a22a	sijon	Jalan	Siap Diambil	\N	85664221560	20		\N	\N	0
1fa2c82b-eaad-4ffc-b7e6-3fac0b751deb	2025-10-17 21:39:13.177826+00	7fd4bb2d-8ece-4197-ba9b-63144011b10d	\N	2025-12-08 12:26:00.339532	8db3f967-5f09-4150-a95b-010faa31a22a	dksdskjd		Siap Diambil	\N	08329283384	21		\N	\N	0
42d05911-6b42-4bfc-85c1-85cf3c1e6161	2025-10-17 21:45:47.686465+00	b65e3685-90b2-4835-a18c-46619ec5f279	\N	2025-12-08 12:26:07.732538	8db3f967-5f09-4150-a95b-010faa31a22a	sijon	Jalan	Siap Diambil	\N	85664221560	22		\N	\N	0
d27fa641-3a9b-4961-bdd3-910828bcee9b	2025-10-22 09:55:32.09191+00	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	\N	2025-12-08 12:26:15.371855	8db3f967-5f09-4150-a95b-010faa31a22a	rama		Siap Diambil	\N	82210357112	26		\N	\N	0
4005c685-15cc-45b9-aa17-8b5a85e6cdbb	2025-10-24 12:19:51.270748+00	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	\N	2025-12-08 12:26:27.376338	8db3f967-5f09-4150-a95b-010faa31a22a	rama		Siap Diambil	\N	082210357112	27		\N	\N	0
1f00b27c-f270-4716-a891-4c7e701eb85e	2025-10-24 12:23:36.679543+00	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	\N	2025-12-08 12:26:41.660594	8db3f967-5f09-4150-a95b-010faa31a22a	rama		Siap Diambil	\N	082210357112	28		\N	\N	0
a57ef7a3-d324-4155-ac55-e8264e3c0b1b	2025-11-02 13:40:42.182896+00	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	\N	2025-12-08 12:27:05.679882	8db3f967-5f09-4150-a95b-010faa31a22a	rama		Siap Diambil	\N	082210357112	29		\N	\N	0
5ddf3c56-7fd6-4c70-8c4f-dd15409c1f51	2025-11-06 13:02:18.861685+00	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	\N	2025-12-08 12:27:16.095175	8db3f967-5f09-4150-a95b-010faa31a22a	rama		Siap Diambil	\N	082210357112	30		\N	\N	0
02c67a86-cdbe-442b-95ce-9cf76a8e7d84	2025-11-10 21:33:18.287387+00	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	\N	2025-12-08 12:27:27.969714	8db3f967-5f09-4150-a95b-010faa31a22a	rama		Siap Diambil	\N	082210357112	33		\N	\N	0
895b8296-c5e9-4f5d-9413-671e1a20d148	2025-11-10 21:00:37.664336+00	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	\N	2025-12-08 12:27:39.105512	8db3f967-5f09-4150-a95b-010faa31a22a	rama		Siap Diambil	\N	082210357112	31	Tesmsksdk(ddksllskknnee ehsjsks ssnsnmammsmnsmsm ssnjskdkkkdd dndkdkkskksf nfjkdkaks sndks snskshske dmskkskdkksbdnrje r rkdkd dddkd r ekahrnrms skdkdndnr djskdnnnam erkdkdbrn ejejksjd r  rjekdks rejejskke 	\N	\N	0
94b6fa54-712c-4784-8e37-801ca06e52f6	2025-11-10 21:18:35.031104+00	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	\N	2025-12-08 12:28:04.176542	8db3f967-5f09-4150-a95b-010faa31a22a	rama		Siap Diambil	\N	082210357112	32	Test catatan	\N	\N	0
e7e0704d-6559-46a0-a70d-cc63d3cc5e93	2025-11-19 13:51:21.412527+00	d8230d29-a0d5-4030-b25a-0b558cad0e9c	\N	2025-12-08 12:28:17.007769	8db3f967-5f09-4150-a95b-010faa31a22a	test		Siap Diambil	\N	8546488948	35	Tes	\N	\N	0
bf148b64-9708-4f2d-9469-cdf802cf31dc	2025-11-18 23:04:49.472902+00	d8230d29-a0d5-4030-b25a-0b558cad0e9c	\N	2025-12-08 12:28:25.540676	8db3f967-5f09-4150-a95b-010faa31a22a	test		Siap Diambil	\N	8546488948	34		\N	\N	0
7b22880c-8fd2-485c-a04f-f70d1ca77216	2025-12-05 22:46:25.817614+00	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	\N	2025-12-08 12:28:36.63498	8db3f967-5f09-4150-a95b-010faa31a22a	rama		Siap Diambil	\N	082210357112	36		\N	\N	0
def56394-968d-4d95-8038-66e511f89e90	2025-12-08 12:18:16.884859+00	b65e3685-90b2-4835-a18c-46619ec5f279	\N	2025-12-10 13:02:10.432803	8db3f967-5f09-4150-a95b-010faa31a22a	Helen	Jalan	Siap Diambil	\N	85664221560	37		\N	\N	0
95e3bcfe-889d-4545-8c92-3d2da9f35a82	2025-12-14 01:22:41.989363+00	d8230d29-a0d5-4030-b25a-0b558cad0e9c	\N	\N	8db3f967-5f09-4150-a95b-010faa31a22a	Jaka		Dibatalkan	\N	8546488948	41	\N	\N	\N	0
7b8f664f-ac53-4059-9bbe-97af430811fc	2025-12-15 22:18:04.892006+00	751b40b5-8b6b-4afb-b051-d2a0d1a9aec0	\N	\N	8db3f967-5f09-4150-a95b-010faa31a22a	rama		Diproses	\N	082210357112	42		\N	\N	0
0f6fa71f-e56c-4342-a6e5-3fa0f95d5b29	2025-12-15 22:37:30.013022+00	6eaf519b-e326-48b2-bb5e-3fc7a9915252	\N	2025-12-17 12:48:09.610227	8db3f967-5f09-4150-a95b-010faa31a22a	Baru	Gggg	Siap Diambil	\N	0853663555	43		\N	\N	0
05e2483b-2aca-4238-ae92-e64fbd05479e	2025-12-08 12:29:24.287587+00	d8230d29-a0d5-4030-b25a-0b558cad0e9c	2025-12-22 12:22:48.812045	2025-12-22 12:22:40.996071	8db3f967-5f09-4150-a95b-010faa31a22a	Jaka		Selesai	\N	8546488948	38		\N	\N	0
50944c9b-4c7b-4925-b59a-7fd557b33788	2025-12-17 12:21:13.657233+00	6eaf519b-e326-48b2-bb5e-3fc7a9915252	\N	2025-12-25 06:54:34.325288	8db3f967-5f09-4150-a95b-010faa31a22a	Baru	Gggg	Siap Diambil	\N	0853663555	44		\N	\N	0
18d77d67-991f-4a13-a28b-64e396c7d559	2025-12-26 15:08:35.3457+00	71f1f332-2dd6-43d3-b6db-31d34b812f9c	\N	\N	20a1b60b-2c45-4533-a02e-ad9d4545b860	Nayla 		Diproses	\N	082331649854	1	Pewangi Mawar	\N	\N	0
53f4fe58-6e38-43a5-8005-ae82cb69661c	2025-12-26 15:14:30.197042+00	71f1f332-2dd6-43d3-b6db-31d34b812f9c	\N	\N	20a1b60b-2c45-4533-a02e-ad9d4545b860	Nayla 	Jl. Melati RT 25 Rumah Nomer 3	Diproses	\N	082331649854	2		\N	\N	0
bb5ba42a-aad8-465e-a260-ab09e41a602f	2025-12-10 13:07:38.682353+00	b65e3685-90b2-4835-a18c-46619ec5f279	\N	2026-01-09 00:14:29.218377	8db3f967-5f09-4150-a95b-010faa31a22a	Helen	Jalan	Siap Diambil	\N	85664221560	40		\N	\N	0
cb621eae-5ca0-4b27-94c7-896d5b68eae8	2025-12-26 12:36:07.71212+00	c8da27c4-d68f-491b-9325-ad877db6b7e8	\N	2026-01-09 00:14:56.336388	8db3f967-5f09-4150-a95b-010faa31a22a	Uuuhuyy		Siap Diambil	\N	082556652258	45		\N	\N	0
28601a0f-8ce3-466d-85b5-d6d7d45902b2	2025-12-08 12:30:29.512289+00	7fd4bb2d-8ece-4197-ba9b-63144011b10d	\N	2026-01-09 14:38:26.471615	8db3f967-5f09-4150-a95b-010faa31a22a	Putri		Siap Diambil	\N	08329283384	39		\N	\N	0
412a9ed7-a746-422d-9bfc-98d35070bd69	2026-02-21 07:42:32.273568+00	a048aed1-c445-4620-bf19-4c5c9233ea08	2026-02-21 07:44:25.854479	2026-02-21 07:44:21.403343	65e7caf4-1316-49da-a3b9-3b7f8fef3955	Joni		Selesai	\N	085664221560	1		\N	\N	0
c948b7be-c928-4d41-a30e-9fee97fc3429	2026-02-21 07:37:55.593539+00	2ce6aedf-1f23-4444-a1a2-e18e6911a22f	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Gaga		Diproses	\N	08262882727	1		2026-02-21 16:02:00.926768	\N	0
2ab4050c-1530-4f34-a012-e28b492c58d2	2026-02-24 13:29:00.732507+00	bc242324-3101-40e3-9f6d-93f58aac0b80	\N	2026-03-11 01:57:06.620993	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Ipul		Siap Diambil	\N	085664221560	12		\N	\N	0
7b9968a6-94c7-4010-b208-3cfc7ed21ef9	2026-02-21 16:07:41.225296+00	bc242324-3101-40e3-9f6d-93f58aac0b80	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Ipul		Diproses	\N	085664221560	4		2026-02-21 16:13:29.139098	\N	0
224661bb-7af0-4c87-a9af-a3d18d785267	2026-02-21 16:14:26.226913+00	2ce6aedf-1f23-4444-a1a2-e18e6911a22f	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Gaga		Diproses	\N	08262882727	5		2026-02-21 16:14:47.171598	\N	0
ebc9fecd-413a-4696-98d1-bd7d853c0a80	2026-02-21 16:15:59.079628+00	2ce6aedf-1f23-4444-a1a2-e18e6911a22f	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Gaga		Diproses	\N	08262882727	6		2026-02-21 16:18:06.282931	\N	0
50a64cb9-6f17-4de2-ab28-8dcf626a0bec	2026-02-21 16:19:58.986374+00	2ce6aedf-1f23-4444-a1a2-e18e6911a22f	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Gaga		Diproses	\N	08262882727	7		2026-02-21 16:20:14.418866	\N	0
905a7ec2-c47d-4797-9355-d13e7138927d	2026-02-21 15:09:57.420029+00	bc242324-3101-40e3-9f6d-93f58aac0b80	\N	2026-02-21 15:53:45.376741	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Ipul		Siap Diambil	\N	085664221560	2		2026-02-21 16:20:33.163705	\N	0
41971f36-3855-401f-a6d1-3c1511de668e	2026-02-21 15:17:41.99924+00	bc242324-3101-40e3-9f6d-93f58aac0b80	2026-02-21 15:18:51.522507	2026-02-21 15:18:47.364733	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Ipul		Selesai	\N	085664221560	3	Ok	2026-02-21 16:21:36.414579	\N	0
a0e0fca8-900e-431f-bd01-13c2eb740c59	2026-02-21 16:21:51.166414+00	bc242324-3101-40e3-9f6d-93f58aac0b80	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Ipul		Diproses	\N	085664221560	8		2026-02-21 16:22:06.576924	\N	0
f29aaf5d-2d01-4f7f-a8ec-5ad27247f890	2026-02-21 16:31:13.122323+00	bc242324-3101-40e3-9f6d-93f58aac0b80	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Ipul		Diproses	\N	085664221560	9		2026-02-21 16:31:27.969849	\N	0
5431b440-fcc1-4120-bf0a-d318743e5287	2026-02-21 16:32:07.096752+00	bc242324-3101-40e3-9f6d-93f58aac0b80	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Ipul		Diproses	\N	085664221560	10		2026-02-21 16:32:18.038707	\N	0
70788efd-9d84-46d9-8218-93f7f05392ad	2026-02-21 16:33:05.553961+00	bc242324-3101-40e3-9f6d-93f58aac0b80	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Ipul		Diproses	\N	085664221560	11		2026-02-21 16:33:12.928291	\N	0
f8813a16-41c0-4f2a-9911-09c3ba012113	2026-02-22 13:42:10.062823+00	edd883bd-66a1-4721-9576-7fe5cdd5d1f9	\N	\N	cf7cfef7-6850-46c2-9efc-22c28cb0922c	Dd		Diproses	\N	082566555666	1		\N	\N	0
88e270fa-841b-41b8-83f6-d5b7d03af423	2026-02-24 13:30:42.589482+00	2ce6aedf-1f23-4444-a1a2-e18e6911a22f	2026-02-24 22:36:52.540199	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Gaga		Selesai	\N	08262882727	13		\N	\N	0
1b1e49e7-5f90-4b59-aea7-3bae79617f46	2026-02-25 10:32:05.330632+00	bc242324-3101-40e3-9f6d-93f58aac0b80	\N	2026-03-11 01:57:24.27741	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Ipul		Siap Diambil	\N	085664221560	16		\N	\N	0
e34ed06f-91e3-4f59-8252-77e468a02616	2026-02-24 23:20:20.252598+00	\N	2026-02-24 23:21:46.673321	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	\N	\N	Selesai	\N	\N	14	\N	2026-02-24 23:25:59.056417	\N	0
67839993-8703-4488-a107-cc68c62b7f4e	2026-02-24 23:23:50.266397+00	b56003d8-63bf-4f32-b4c2-58c810313a68	2026-02-27 01:52:09.068039	2026-02-27 01:52:05.904145	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon	sdfasdf	Selesai	ipulm@gmail.com	085664221560	15	\N	\N	\N	0
a9b9f077-c256-4c99-86a9-e0c376b5f496	2026-02-27 23:52:11.360629+00	84521ce9-8f91-43e3-aebc-1b5bf002d2f1	\N	\N	4b843f69-8041-4846-8af4-872de4c5c41e	Pelanggan1		Diproses	\N	08288888888	1		\N	\N	0
bfa5d795-5866-4fe2-9cb2-81e83acf7b38	2026-03-10 13:12:44.094029+00	b56003d8-63bf-4f32-b4c2-58c810313a68	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon2	sdfasdf	Diproses	\N	085664221560	18		\N	\N	0
7276fb30-d2eb-4d68-8b5d-c21434ff1f5a	2026-03-09 16:51:26.833205+00	b56003d8-63bf-4f32-b4c2-58c810313a68	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon	sdfasdf	Diproses	ipulm@gmail.com	085664221560	17	\N	\N	\N	2000
69f5d6f0-f634-4ee5-b89c-27035c44ad3a	2026-03-10 13:26:33.535879+00	b56003d8-63bf-4f32-b4c2-58c810313a68	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon2	sdfasdf	Diproses	\N	085664221560	20		\N	\N	7000
19faa009-c44e-406e-a944-31b09c8f4d9a	2026-03-10 13:13:17.864103+00	b56003d8-63bf-4f32-b4c2-58c810313a68	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon2	sdfasdf	Diproses	\N	085664221560	19		\N	\N	36
ce77ff93-c08b-4b47-b52c-46dc875d1d83	2026-03-10 13:44:57.505596+00	b56003d8-63bf-4f32-b4c2-58c810313a68	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon2	sdfasdf	Diproses	\N	085664221560	21	Ggggg	\N	\N	36
b2a26589-e8b7-4b95-9621-52743d5660b5	2026-03-10 23:04:43.043622+00	2ce6aedf-1f23-4444-a1a2-e18e6911a22f	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Gaga		Diproses	\N	08262882727	22		\N	8a0aeb65-5f82-48c3-be7e-4f684e4fdd89	3600
ec6d86a0-8605-4401-b820-51d9b474a264	2026-03-10 23:06:46.743341+00	2ce6aedf-1f23-4444-a1a2-e18e6911a22f	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Gaga		Diproses	\N	08262882727	23		\N	8a0aeb65-5f82-48c3-be7e-4f684e4fdd89	1680
d4e5158d-4190-4a50-b087-7cec89d76659	2026-03-11 17:39:17.258734+00	b56003d8-63bf-4f32-b4c2-58c810313a68	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon2	sdfasdf	Diproses	\N	085664221560	24	\N	\N	\N	0
4137dfaa-4c90-41c9-a14b-5c503ade6c68	2026-03-11 17:39:57.396226+00	b56003d8-63bf-4f32-b4c2-58c810313a68	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon2	sdfasdf	Diproses	\N	085664221560	25	\N	\N	\N	0
b38a3f30-f978-4001-bfc0-1c59b4b4bae9	2026-03-11 18:00:44.922534+00	b56003d8-63bf-4f32-b4c2-58c810313a68	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon2	sdfasdf	Diproses	\N	085664221560	26	\N	\N	\N	0
6e56c1b3-0e7e-4494-ae71-153f316b8f4f	2026-03-12 00:52:12.564554+00	b56003d8-63bf-4f32-b4c2-58c810313a68	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon2	sdfasdf	Diproses	\N	085664221560	27	Hhh	\N	8a0aeb65-5f82-48c3-be7e-4f684e4fdd89	8160
e6a66e22-181f-478d-898a-15781e6e13ba	2026-03-12 02:02:16.018691+00	2ce6aedf-1f23-4444-a1a2-e18e6911a22f	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Gaga		Diproses	\N	08262882727	28		\N	\N	0
c2371b6b-b04e-4f3b-b4de-07b061659d81	2026-03-12 02:19:29.485185+00	2ce6aedf-1f23-4444-a1a2-e18e6911a22f	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Gaga		Diproses	\N	08262882727	29		\N	0b627f22-f7f9-4c2c-80db-672ae67a9e1f	12500
2c0e2d7d-8bbb-4c45-ba27-878e05efb65a	2026-03-15 21:37:24.371632+00	b56003d8-63bf-4f32-b4c2-58c810313a68	\N	\N	9d659c1f-c68f-4f69-9e21-fbcf37432bab	jon2	sdfasdf	Diproses	\N	085664221560	30	\N	\N	\N	0
\.


--
-- Data for Name: transaction_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transaction_item (id, created_at, service_id, qty, service_unit, transaction_id, service_name, price, duration_id, duration_name, duration_length, duration_length_type, estimated_date) FROM stdin;
1aee75d5-e932-40b3-a73d-2ce3fbf0b8cc	2025-10-10 13:13:28.685432+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	12	KG	e217fe0b-36c3-4264-a1c5-d2d2697891cd	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-13 13:13:28.122
d4e8101a-f276-43df-808d-9c7b9f6a7576	2025-10-10 13:21:53.611841+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	12	KG	f4d3a0ab-1f3e-425f-96fd-e4cc6217950f	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-13 20:21:53.435
79c61dd5-6d59-40bc-9d5a-976a77de3f66	2025-10-11 08:26:38.594724+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	12	KG	e09d4a5e-a4cc-44de-b20f-844ca4766821	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-14 15:26:37.764
854dd8c2-b1a5-4ce9-a670-38bcd154e2ad	2025-10-11 08:26:38.643178+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	12	KG	e09d4a5e-a4cc-44de-b20f-844ca4766821	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-12 15:26:37.764
4e37733a-0192-40ac-be76-867450b0d601	2025-10-17 13:28:29.026035+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	ffd03e9e-c787-40ad-afa1-4dd490b40e80	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-18 13:28:27.555
da396360-f814-435c-a6bf-e3fa8c9959e3	2025-10-17 13:28:29.253682+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	ffd03e9e-c787-40ad-afa1-4dd490b40e80	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:28:27.555
9c2910f3-e9d4-4826-b062-acc668883ce4	2025-10-17 13:28:29.481206+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	ffd03e9e-c787-40ad-afa1-4dd490b40e80	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:28:27.555
6d3bef7f-e4a4-4039-a7f4-753f2ac2751b	2025-10-17 13:31:38.152446+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	8a3b8432-8441-4e57-bef4-89be1dd0f578	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:31:36.745
cd1503f1-69f4-4666-b41c-d8dc3dc4f05f	2025-10-17 13:31:38.380859+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	8a3b8432-8441-4e57-bef4-89be1dd0f578	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:31:36.745
e96db4df-7c38-4b15-8450-fefdbb8f8a3f	2025-10-17 13:31:38.608344+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	8a3b8432-8441-4e57-bef4-89be1dd0f578	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:31:36.745
52af53e9-10a8-4b63-8922-cd1f1cbf317f	2025-10-17 13:35:18.341843+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	90b7cb1b-c809-4372-9c5c-ddca831b7a51	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:35:16.939
ac6c8694-2bc2-4f3d-b0df-5eea86620a27	2025-10-17 13:35:18.572879+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	90b7cb1b-c809-4372-9c5c-ddca831b7a51	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:35:16.939
a2eaea32-309a-4e0c-8fed-06a39343e826	2025-10-17 13:35:18.805561+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	90b7cb1b-c809-4372-9c5c-ddca831b7a51	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:35:16.939
a8ea4418-f24a-4885-ae18-d90d0eb5d6d3	2025-10-17 13:36:03.267481+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	75d8ba9c-1ad5-4970-afd4-e001cfddd1b0	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:36:01.879
ab75e1c0-b9a7-42b8-8316-5ce0494774b4	2025-10-17 13:36:03.495478+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	75d8ba9c-1ad5-4970-afd4-e001cfddd1b0	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:36:01.879
ca6f0d95-4c09-4ef3-8a1e-52fdbe4e3624	2025-10-17 13:36:03.722917+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	75d8ba9c-1ad5-4970-afd4-e001cfddd1b0	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:36:01.879
c2844525-6da2-4a7f-9325-00d63cb3999c	2025-10-17 13:36:32.475606+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	2ca8ad49-b3b9-4a01-8285-9883f34df992	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:36:31.057
0ed74dfd-04dc-4305-b8b6-7bc121f468a4	2025-10-17 13:36:32.702686+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	2ca8ad49-b3b9-4a01-8285-9883f34df992	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:36:31.057
5a6ed716-8cbc-4eec-b85f-a537db76e0cf	2025-10-17 13:36:32.928973+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	2ca8ad49-b3b9-4a01-8285-9883f34df992	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:36:31.057
4b963b8b-7a77-4563-a21a-5d8389c7ed9b	2025-10-17 13:37:18.465859+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	1b12893c-f23d-4c62-9f47-f498904fb0db	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:37:17.036
3fd07b91-91f9-41f3-887c-a10f5383cb63	2025-10-17 13:37:18.679979+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	1b12893c-f23d-4c62-9f47-f498904fb0db	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:37:17.036
265015c5-91bb-4243-9ef0-b35681b74e0b	2025-10-17 13:37:18.893976+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	1b12893c-f23d-4c62-9f47-f498904fb0db	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:37:17.036
a150b5ad-0151-4e7d-840b-a9878833d3bc	2025-10-17 13:39:18.793149+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	9afc00ea-4b0b-4c69-a2c2-1c970401fef9	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:39:17.446
b5531b32-6baf-4aaa-a01f-9a7d3780d09c	2025-10-17 13:39:19.013835+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	9afc00ea-4b0b-4c69-a2c2-1c970401fef9	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:39:17.446
9bb32b93-4ccf-473d-a3f9-364ceaf8e50e	2025-10-17 13:39:19.234469+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	9afc00ea-4b0b-4c69-a2c2-1c970401fef9	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:39:17.446
d6aaaf31-0465-4678-9af9-ff600086563b	2025-10-17 13:39:57.673714+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	5dde48c9-9352-4213-a5f2-e7e059fc435d	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:39:56.226
5b9c4348-5a51-4d1b-a9f5-1a78208d9178	2025-10-17 13:39:57.898191+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	5dde48c9-9352-4213-a5f2-e7e059fc435d	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:39:56.226
1d792d1f-b269-42f5-a0ca-f442b8d07bfe	2025-10-17 13:39:58.122823+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	5dde48c9-9352-4213-a5f2-e7e059fc435d	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:39:56.226
b13f18cf-1a59-40d8-b389-61286c01d067	2025-10-17 13:40:34.600594+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	c79e4d4d-366f-45ef-8e80-f6c8683ac8ea	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:40:33.176
c82c2dc5-9627-4460-b905-1960036069da	2025-10-17 13:40:34.813609+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	c79e4d4d-366f-45ef-8e80-f6c8683ac8ea	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:40:33.176
6008acfd-2dac-44e3-a074-a019c01756d0	2025-10-17 13:40:35.025624+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	c79e4d4d-366f-45ef-8e80-f6c8683ac8ea	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:40:33.176
d455d1a2-470d-4853-9b09-52b12cb4da34	2025-10-17 13:42:25.752968+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	e6a8eb85-1539-483d-9c79-cdf95b4f36af	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:42:24.321
e01c70e9-2b71-44cf-abbe-fecf585eb318	2025-10-17 13:42:25.985816+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	e6a8eb85-1539-483d-9c79-cdf95b4f36af	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:42:24.321
13b7ef01-b82b-4cff-be51-f58f6536cf18	2025-10-17 13:42:26.214148+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	e6a8eb85-1539-483d-9c79-cdf95b4f36af	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:42:24.321
11d3d4a6-8fda-44cd-a662-79e6759de7cb	2025-10-17 13:42:57.861697+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	8ac553fc-d111-487d-96bf-c14e2447d128	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:42:56.442
b111fd49-694d-4d24-a1bf-92833e237fc2	2025-10-17 13:42:58.084681+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	8ac553fc-d111-487d-96bf-c14e2447d128	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:42:56.442
2e9c511b-b569-4c3d-b210-2b09311528a8	2025-10-17 13:42:58.307778+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	8ac553fc-d111-487d-96bf-c14e2447d128	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:42:56.442
b0ff61f6-4c40-4053-a30f-7a015ae49650	2025-10-17 13:43:26.108096+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	5f6b6df0-53ef-4ac2-ba36-ee36dee6e901	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:43:24.75
68ab52dd-d74c-499f-a968-77263f6b3ac4	2025-10-17 13:43:26.327165+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	5f6b6df0-53ef-4ac2-ba36-ee36dee6e901	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:43:24.75
e3d87b0f-bada-45ec-8c35-e378a73b0d4f	2025-10-17 13:43:26.547163+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	5f6b6df0-53ef-4ac2-ba36-ee36dee6e901	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:43:24.75
665cb295-cd62-4d18-8179-c14ac409d631	2025-10-17 13:52:29.037165+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	f522e287-fb13-41a2-8bbf-63d76ffbc006	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:52:26.21
1be469a5-b7ce-41ac-81aa-7ffd83ce9416	2025-10-17 13:52:29.269437+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	f522e287-fb13-41a2-8bbf-63d76ffbc006	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:52:26.21
70e3f675-e464-47f8-a254-9293d1c21040	2025-10-17 13:52:29.499373+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	f522e287-fb13-41a2-8bbf-63d76ffbc006	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:52:26.21
63c831e9-b76f-4f55-a2c1-d36c23559990	2025-10-17 13:52:29.73121+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	f522e287-fb13-41a2-8bbf-63d76ffbc006	Kiloan - Cuci	6000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-18 13:52:26.21
e77de067-def8-43b7-aebf-77111438c078	2025-10-17 13:52:29.959506+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	f522e287-fb13-41a2-8bbf-63d76ffbc006	Kiloan - Cuci	8000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:52:26.21
c5d880d5-db6f-4bfc-b50f-f6159fdc2924	2025-10-17 13:52:30.187036+00	8facb3b2-777f-4fdf-aa67-0a09ce345593	1	PCS	f522e287-fb13-41a2-8bbf-63d76ffbc006	Jas	20000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:52:26.21
1b29dcf6-664a-40c2-b6dd-7395edb9a5c8	2025-10-17 13:55:55.437332+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	6083db98-a0de-4f5f-aed0-48bc034fb8f8	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:55:52.651
c18520ca-0f1c-40ba-9745-b576daecaf48	2025-10-17 13:55:55.660318+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	6083db98-a0de-4f5f-aed0-48bc034fb8f8	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:55:52.651
40dbcb7f-5749-48c4-9a05-31a918514a10	2025-10-17 13:55:55.877924+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	6083db98-a0de-4f5f-aed0-48bc034fb8f8	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:55:52.651
5250d8ca-ada9-4744-bfea-7a24b43daa00	2025-10-17 13:55:56.094311+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	6083db98-a0de-4f5f-aed0-48bc034fb8f8	Kiloan - Cuci	6000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-18 13:55:52.651
ede865a7-6f42-45ce-9428-e3c16ceffe3d	2025-10-17 13:55:56.311513+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	6083db98-a0de-4f5f-aed0-48bc034fb8f8	Kiloan - Cuci	8000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:55:52.651
e2916fd9-f7eb-45fd-b654-2f3c90bdeb05	2025-10-17 13:55:56.527247+00	8facb3b2-777f-4fdf-aa67-0a09ce345593	1	PCS	6083db98-a0de-4f5f-aed0-48bc034fb8f8	Jas	20000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:55:52.651
b240c3b4-9b11-4fbb-a2d3-ce571b11c7f8	2025-10-17 13:58:52.93243+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	11d0a36c-a55b-42a2-a523-8da140667f5a	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 13:58:51.476
89b18214-31d4-4f9d-b063-d741d7c6306e	2025-10-17 13:58:53.176667+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	11d0a36c-a55b-42a2-a523-8da140667f5a	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-18 13:58:51.476
68e69a5d-8a6b-48ac-ad7e-b293f84457cc	2025-10-17 13:58:53.409926+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	11d0a36c-a55b-42a2-a523-8da140667f5a	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-17 19:58:51.476
7346166a-e3fa-4ded-a62d-7933dea182a4	2025-10-17 21:31:36.737694+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	3b246b84-8bd2-4fa5-9f31-d77eeec50808	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 21:31:35.36
a040b89c-1747-40fc-87a5-d22b24557ffd	2025-10-17 21:31:36.962094+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	3b246b84-8bd2-4fa5-9f31-d77eeec50808	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-18 21:31:35.36
34eb7b46-1c82-4b66-a38c-1d31407654a2	2025-10-17 21:31:37.183051+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	3b246b84-8bd2-4fa5-9f31-d77eeec50808	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-18 03:31:35.36
d2905510-a1f9-4f76-9d3b-14caaefbcca3	2025-10-17 21:36:57.928688+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	54d871be-87d5-4675-acf1-c67e1b7387a5	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 21:36:56.993
e9c4a598-1fda-49ac-aeee-9d6a0577f4ff	2025-10-17 21:36:58.149623+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	54d871be-87d5-4675-acf1-c67e1b7387a5	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 21:36:56.993
613baf61-22dd-4a58-bd73-19bf9fb9b904	2025-10-17 21:39:14.747016+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	1fa2c82b-eaad-4ffc-b7e6-3fac0b751deb	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 21:39:13.309
1955de08-4cef-464a-b0be-29a7c5d21baa	2025-10-17 21:39:14.970756+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	1fa2c82b-eaad-4ffc-b7e6-3fac0b751deb	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-18 21:39:13.309
27e6589d-5c3b-4b77-b717-9e140d3553b3	2025-10-17 21:39:15.191898+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	1fa2c82b-eaad-4ffc-b7e6-3fac0b751deb	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-18 03:39:13.309
8f432db6-8177-40ca-ac17-229a7c93de24	2025-10-17 21:45:48.744422+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	42d05911-6b42-4bfc-85c1-85cf3c1e6161	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-20 21:45:47.807
dc76cc53-2e2f-4739-9944-e914a5b363fa	2025-10-17 21:45:48.969338+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	42d05911-6b42-4bfc-85c1-85cf3c1e6161	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-18 03:45:47.807
f1b9cb61-f7bf-41b0-bb27-ba60c94cfb54	2025-10-17 21:50:26.009018+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	d64225d9-4684-4f07-9f6e-1f4dfacdfb07	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-18 21:50:25.008
2ca29c5f-5bde-49cd-bf3e-a3211f61e65e	2025-10-17 21:50:26.230422+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	d64225d9-4684-4f07-9f6e-1f4dfacdfb07	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-18 03:50:25.008
f16f7095-d618-4530-a081-ece2403fd4d2	2025-10-18 22:24:23.615977+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	c21b4e83-45e8-4ce9-8ff9-1abc78b5dd20	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-19 22:24:22.562
a10148b3-57bc-4e0b-8fbd-c795a4fc3474	2025-10-18 22:24:23.838557+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	c21b4e83-45e8-4ce9-8ff9-1abc78b5dd20	Kiloan - Cuci, Setrika	12000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-10-19 04:24:22.562
66a0c8e8-d855-46e3-87d1-6c87871109af	2025-10-19 12:32:40.605701+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	30575655-aa99-482f-be0b-637da76e3e62	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-22 12:32:39.582
543dbb9d-75b4-4fae-b4e4-5baf959909e0	2025-10-19 12:32:40.823297+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	30575655-aa99-482f-be0b-637da76e3e62	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-20 12:32:39.582
d1fb0802-12ca-415d-87b7-821ed7164bc9	2025-10-22 09:55:33.234225+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	d27fa641-3a9b-4961-bdd3-910828bcee9b	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-25 09:55:32.265
da1b2efe-a23c-4269-88de-e0c6fdabd6c6	2025-10-22 09:55:33.456128+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	d27fa641-3a9b-4961-bdd3-910828bcee9b	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-23 09:55:32.265
8f74db0c-76dd-4030-a38d-34ee5a84b48f	2025-10-24 12:19:52.390755+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	4005c685-15cc-45b9-aa17-8b5a85e6cdbb	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-27 12:19:51.399
05decdcd-1cf8-44d5-ac30-4406b756143f	2025-10-24 12:19:52.614275+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	4005c685-15cc-45b9-aa17-8b5a85e6cdbb	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-25 12:19:51.399
0755a447-ee01-4ebd-805e-6f48065c4646	2025-10-24 12:23:37.771793+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	2	KG	1f00b27c-f270-4716-a891-4c7e701eb85e	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-10-27 12:23:36.796
87a46ce6-b14e-404b-a4df-b9fa516e1a1a	2025-10-24 12:23:37.996441+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	2	KG	1f00b27c-f270-4716-a891-4c7e701eb85e	Kiloan - Cuci, Setrika	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-10-25 12:23:36.796
0f3cb112-da99-4003-bd39-844aeefa0069	2025-11-02 13:40:42.868978+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	1	KG	a57ef7a3-d324-4155-ac55-e8264e3c0b1b	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-11-05 13:40:42.383
f5cf2250-b25b-418d-861f-e178c4e2f8a4	2025-11-06 13:02:19.554472+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	3	KG	5ddf3c56-7fd6-4c70-8c4f-dd15409c1f51	Kiloan - Cuci, Setrika	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-11-09 13:02:19.046
18b1d182-d884-42af-ae0e-ce05f870fce7	2025-11-10 21:00:38.753066+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	895b8296-c5e9-4f5d-9413-671e1a20d148	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-11-13 21:00:37.841
ae7f760a-fd1d-44a5-b313-53fb4803aa8b	2025-11-10 21:00:38.984897+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	895b8296-c5e9-4f5d-9413-671e1a20d148	Kiloan - Cuci	6000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-11-11 21:00:37.841
82308bea-1ad4-4182-a89e-002490891689	2025-11-10 21:18:35.672199+00	3950254c-8f5d-4e88-817e-14c7d2dcac2a	1	KG	94b6fa54-712c-4784-8e37-801ca06e52f6	Kiloan - Cuci	4000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-11-13 21:18:35.186
d5dabf3e-fbfa-48c9-9dd6-7ef0f238aba6	2025-11-10 21:33:18.966177+00	34efee85-0e62-4bee-bbc1-3257cadf4c49	1	PCS	02c67a86-cdbe-442b-95ce-9cf76a8e7d84	Boneka	20000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-11-11 21:33:18.428
26bf6f4d-64d3-476a-a338-a0db26ddd00d	2025-11-18 23:04:50.137972+00	8facb3b2-777f-4fdf-aa67-0a09ce345593	1	PCS	bf148b64-9708-4f2d-9469-cdf802cf31dc	Jas	20000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-11-21 23:04:49.609
0c537b8b-7ae5-4f61-ad42-e41d743c52b2	2025-11-19 13:51:22.095665+00	8facb3b2-777f-4fdf-aa67-0a09ce345593	1	PCS	e7e0704d-6559-46a0-a70d-cc63d3cc5e93	Jas	25000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-11-20 13:51:21.532
2ff6a63e-6bdc-45dd-80b9-d4cdd1107ef7	2025-12-05 22:46:26.891578+00	32baf08b-23ef-4ac6-9154-f60465a1a66a	1	uuih	7b22880c-8fd2-485c-a04f-f70d1ca77216	fggh	23	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	6	Jam	2025-12-06 04:46:25.955
ccee4b55-04bb-401d-bc82-1ec16bf7ba59	2025-12-05 22:46:27.114051+00	32baf08b-23ef-4ac6-9154-f60465a1a66a	1	uuih	7b22880c-8fd2-485c-a04f-f70d1ca77216	fggh	36	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-12-06 22:46:25.955
f35bb9a2-a50c-453d-ad1b-cf75968ff3df	2025-12-08 12:18:18.004411+00	32baf08b-23ef-4ac6-9154-f60465a1a66a	1	uuih	def56394-968d-4d95-8038-66e511f89e90	fggh	23	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	32	Jam	2025-12-09 20:18:17.034
181ca007-043b-45a8-85ae-d8bb62cdb9c9	2025-12-08 12:18:18.224457+00	32baf08b-23ef-4ac6-9154-f60465a1a66a	2	uuih	def56394-968d-4d95-8038-66e511f89e90	fggh	36	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-12-09 12:18:17.034
37ea636a-c302-46c2-986d-dbd30fbedc1f	2025-12-08 12:29:25.39906+00	32baf08b-23ef-4ac6-9154-f60465a1a66a	1	uuih	05e2483b-2aca-4238-ae92-e64fbd05479e	fggh	23	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	32	Jam	2025-12-09 20:29:24.436
c108bdb1-152e-435a-9073-4d6ce552d430	2025-12-08 12:29:25.614689+00	32baf08b-23ef-4ac6-9154-f60465a1a66a	1	uuih	05e2483b-2aca-4238-ae92-e64fbd05479e	fggh	996	d2770b2d-f45b-4da4-97f3-adc22222a0c4	gggg	1	Hari	2025-12-09 12:29:24.436
506f83c7-6f68-4711-9875-9714ac48ce99	2025-12-08 12:30:30.607572+00	f53e3edd-c4aa-433c-a122-af1ac430ccaf	1	PCS	28601a0f-8ce3-466d-85b5-d6d7d45902b2	Bedcover	100003	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-12-09 12:30:29.655
3aa94d41-dccc-42b7-9556-88fbd58b0110	2025-12-08 12:30:30.819586+00	f53e3edd-c4aa-433c-a122-af1ac430ccaf	1	PCS	28601a0f-8ce3-466d-85b5-d6d7d45902b2	Bedcover	15000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	32	Jam	2025-12-09 20:30:29.655
c3da55db-f44e-4b67-a403-2c4510875dbc	2025-12-10 13:07:39.761586+00	32baf08b-23ef-4ac6-9154-f60465a1a66a	2	uuih	bb5ba42a-aad8-465e-a260-ab09e41a602f	fggh	23	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	32	Jam	2025-12-11 21:07:38.843
ffd23690-c261-46c5-909f-53b6da825585	2025-12-10 13:07:39.986168+00	32baf08b-23ef-4ac6-9154-f60465a1a66a	45	uuih	bb5ba42a-aad8-465e-a260-ab09e41a602f	fggh	36	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-12-11 13:07:38.843
b5afb002-b46f-4514-a7fa-ffe1b6ab05f2	2025-12-14 01:22:42.255736+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	12	KG	95e3bcfe-889d-4545-8c92-3d2da9f35a82	Kiloan - Cuci, Setrika rr	6000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-12-17 08:22:41.707
66156357-184c-4138-9445-17a84e06da00	2025-12-14 01:22:42.301673+00	1e7e09da-50e8-4627-85ea-2edc6c6d9616	12	KG	95e3bcfe-889d-4545-8c92-3d2da9f35a82	Kiloan - Cuci, Setrika rr	8000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-12-15 08:22:41.707
17ce76ec-ef5d-472e-b84c-1c28d485083c	2025-12-15 22:18:06.422075+00	6881c6eb-7f7b-4bce-91cc-f94036d5e8a5	1	uu	7b8f664f-ac53-4059-9bbe-97af430811fc	yyy	25000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-12-18 22:18:05.052
4963757e-e297-479f-ba2f-a00babf0da6c	2025-12-15 22:18:06.645229+00	34efee85-0e62-4bee-bbc1-3257cadf4c49	2	PCS	7b8f664f-ac53-4059-9bbe-97af430811fc	Boneka	20000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-12-16 22:18:05.052
23af5bc8-5dbb-47dc-8628-672779ab22eb	2025-12-15 22:18:06.864924+00	475d6800-de27-46e7-86d1-2b70b6251ae6	1	PCS	7b8f664f-ac53-4059-9bbe-97af430811fc	Selimut	5000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-12-18 22:18:05.052
b2ce6a8d-144e-4ad9-93e7-2362c3e6902e	2025-12-15 22:37:30.681415+00	6881c6eb-7f7b-4bce-91cc-f94036d5e8a5	1	uu	0f6fa71f-e56c-4342-a6e5-3fa0f95d5b29	yyy	1200	329b1676-cc02-406f-b4e4-6cf5770f1099	bs	5	Jam	2025-12-16 03:37:30.168
e978ba44-da22-4520-bcf5-cfa84cc1dd01	2025-12-17 12:21:14.814495+00	475d6800-de27-46e7-86d1-2b70b6251ae6	1	PCS	50944c9b-4c7b-4925-b59a-7fd557b33788	Selimut	10000	f9e92872-603a-4a2f-a0c2-617ab0472d4b	Express	1	Hari	2025-12-18 12:21:13.784
d7957b95-f0fc-4b18-991f-2dbd0c5f6687	2025-12-17 12:21:15.031208+00	475d6800-de27-46e7-86d1-2b70b6251ae6	1	PCS	50944c9b-4c7b-4925-b59a-7fd557b33788	Selimut	15000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	32	Jam	2025-12-18 20:21:13.784
c24ab858-d804-4052-9dd7-503c456b1754	2025-12-26 12:36:09.311706+00	6881c6eb-7f7b-4bce-91cc-f94036d5e8a5	1	uu	cb621eae-5ca0-4b27-94c7-896d5b68eae8	yyy	1200	329b1676-cc02-406f-b4e4-6cf5770f1099	bs	5	Jam	2025-12-26 17:36:07.897
a361b5ff-d345-4db8-a386-00bebb93da78	2025-12-26 12:36:09.529898+00	6881c6eb-7f7b-4bce-91cc-f94036d5e8a5	1	uu	cb621eae-5ca0-4b27-94c7-896d5b68eae8	yyy	25000	1a410093-18cc-46f7-9c14-28c356ac75c3	Reguler	3	Hari	2025-12-29 12:36:07.897
0f6a1480-4371-458a-9c92-9854ac080081	2025-12-26 12:36:09.74248+00	34efee85-0e62-4bee-bbc1-3257cadf4c49	3	PCS	cb621eae-5ca0-4b27-94c7-896d5b68eae8	Boneka	10000	26dbce97-4e72-4e4c-83a2-2b06c6834dc0	Kilat	32	Jam	2025-12-27 20:36:07.897
10797f0f-5f8e-4404-ac82-39c552fefb8d	2025-12-26 15:08:36.036984+00	23e40e3e-12a5-4b5d-9ca2-220c7a0d6c1f	1	KG	18d77d67-991f-4a13-a28b-64e396c7d559	Kiloan - Cuci, Setrika	6000	50be6b4e-2cef-499c-a660-6293a8f512bc	Reguler	3	Hari	2025-12-29 15:08:35.458
02441cf3-6b20-4517-93ae-6c39b2262489	2025-12-26 15:14:30.873151+00	23e40e3e-12a5-4b5d-9ca2-220c7a0d6c1f	1	KG	53f4fe58-6e38-43a5-8005-ae82cb69661c	Kiloan - Cuci, Setrika	6000	50be6b4e-2cef-499c-a660-6293a8f512bc	Reguler	3	Hari	2025-12-29 15:14:30.309
dc605f4a-65bf-4b8b-8d6c-0327bad322c5	2026-02-21 07:37:57.552162+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	c948b7be-c928-4d41-a30e-9fee97fc3429	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 07:37:55.763
2d264962-dd94-4459-b5c2-458029a27a5f	2026-02-21 07:37:57.778246+00	4b628038-6129-4e40-bb49-2243db2a3188	2	KG	c948b7be-c928-4d41-a30e-9fee97fc3429	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-02-22 07:37:55.763
3b99512a-7af4-438a-910f-6f7b47dc321b	2026-02-21 07:37:57.993355+00	4b628038-6129-4e40-bb49-2243db2a3188	33	KG	c948b7be-c928-4d41-a30e-9fee97fc3429	Kiloan - Cuci, Setrika	12000	f431deb8-0d2f-4b10-88c2-eacc6e840490	Kilat	6	Jam	2026-02-21 13:37:55.763
a7ae7e76-174e-44ba-9eae-5d2f4035a889	2026-02-21 07:37:58.208491+00	2856178c-806a-4f2d-90c8-63f05bddb27b	1	KG	c948b7be-c928-4d41-a30e-9fee97fc3429	Kiloan - Cuci	4000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 07:37:55.763
0e8e6181-e8d3-45bd-aa38-29451adca1f9	2026-02-21 07:42:33.350045+00	77c5e880-423f-4f2a-af97-36bc9902b934	2	KG	412a9ed7-a746-422d-9bfc-98d35070bd69	Kiloan - Cuci, Setrika	6000	ff9c402f-c5ee-4a69-a02b-248cf1f0e89a	Reguler	3	Hari	2026-02-24 07:42:32.386
5fc890b6-7305-4cd1-8036-cbeba142fe9f	2026-02-21 07:42:33.565302+00	77c5e880-423f-4f2a-af97-36bc9902b934	3	KG	412a9ed7-a746-422d-9bfc-98d35070bd69	Kiloan - Cuci, Setrika	8000	238cf216-0a1e-4f8f-8897-a5aa0d8f45c9	Express	1	Hari	2026-02-22 07:42:32.386
62c0f159-a4a0-4efa-bfc8-ebe0fb4ef780	2026-02-21 15:09:58.596377+00	4b628038-6129-4e40-bb49-2243db2a3188	2	KG	905a7ec2-c47d-4797-9355-d13e7138927d	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 15:09:57.599
d9e58706-c328-4713-b83a-cc37dc83ca98	2026-02-21 15:09:58.840247+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	905a7ec2-c47d-4797-9355-d13e7138927d	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-02-22 15:09:57.599
fd5b4909-531a-4ed4-8de2-dbe2244af461	2026-02-21 15:17:42.658819+00	4b628038-6129-4e40-bb49-2243db2a3188	3.2	KG	41971f36-3855-401f-a6d1-3c1511de668e	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 15:17:42.123
75fcce10-c1c4-4f99-8dd0-23c5f440e716	2026-02-21 16:07:41.88284+00	4b628038-6129-4e40-bb49-2243db2a3188	1.2	KG	7b9968a6-94c7-4010-b208-3cfc7ed21ef9	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 16:07:41.392
c2022c19-5327-417f-ab23-861b42a52913	2026-02-21 16:14:26.894445+00	4b628038-6129-4e40-bb49-2243db2a3188	36	KG	224661bb-7af0-4c87-a9af-a3d18d785267	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 16:14:26.398
28b60a8a-bd77-4b6c-b8e6-a51984ecfaa2	2026-02-21 16:16:00.14961+00	4b628038-6129-4e40-bb49-2243db2a3188	2	KG	ebc9fecd-413a-4696-98d1-bd7d853c0a80	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 16:15:59.24
49e5bc6b-1407-4c60-8410-3fce775b74b0	2026-02-21 16:16:00.372121+00	4b628038-6129-4e40-bb49-2243db2a3188	3	KG	ebc9fecd-413a-4696-98d1-bd7d853c0a80	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-02-22 16:15:59.24
1575332a-f8d1-4b04-8493-0e0a6251813b	2026-02-21 16:19:59.667476+00	4b628038-6129-4e40-bb49-2243db2a3188	2	KG	50a64cb9-6f17-4de2-ab28-8dcf626a0bec	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 16:19:59.147
3491a679-bcdd-4c4e-b611-932f06bd9855	2026-02-21 16:21:51.847676+00	4b628038-6129-4e40-bb49-2243db2a3188	2	KG	a0e0fca8-900e-431f-bd01-13c2eb740c59	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 16:21:51.324
90d04726-8d03-49a3-885f-fa2ea4f0f3de	2026-02-21 16:31:13.800556+00	4b628038-6129-4e40-bb49-2243db2a3188	2.96	KG	f29aaf5d-2d01-4f7f-a8ec-5ad27247f890	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 16:31:13.243
38329172-8595-4746-b0d7-a64c73626830	2026-02-21 16:32:07.749695+00	4b628038-6129-4e40-bb49-2243db2a3188	2	KG	5431b440-fcc1-4120-bf0a-d318743e5287	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 16:32:07.22
17bee2a1-c929-4b1c-8130-3440e73cb345	2026-02-21 16:33:06.20505+00	4b628038-6129-4e40-bb49-2243db2a3188	2	KG	70788efd-9d84-46d9-8218-93f7f05392ad	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-24 16:33:05.678
7c079935-41d6-49d3-b75b-dd8a76a46e7a	2026-02-22 13:42:11.169977+00	4af2b638-8c6c-4a20-9340-d9be3bffa6e9	1	KG	f8813a16-41c0-4f2a-9911-09c3ba012113	Kiloan - Cuci, Setrika	6000	03851633-508b-45e9-84da-e9efba545cf7	Reguler	3	Hari	2026-02-25 13:42:10.192
bdcb522e-e568-4e53-a6f4-e32ce7a6ea04	2026-02-22 13:42:11.391316+00	4af2b638-8c6c-4a20-9340-d9be3bffa6e9	2.5	KG	f8813a16-41c0-4f2a-9911-09c3ba012113	Kiloan - Cuci, Setrika	8000	87966686-2950-42a4-af9a-4bad571ae99e	Express	1	Hari	2026-02-23 13:42:10.192
663e1086-b49b-46db-8f49-b53a5e166026	2026-02-24 13:29:01.890758+00	4b628038-6129-4e40-bb49-2243db2a3188	2	KG	2ab4050c-1530-4f34-a012-e28b492c58d2	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-27 13:29:00.87
08b14fc4-b7b8-46d6-8ec4-ed9eede8b07f	2026-02-24 13:29:02.110958+00	4b628038-6129-4e40-bb49-2243db2a3188	2	KG	2ab4050c-1530-4f34-a012-e28b492c58d2	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-02-25 13:29:00.87
c81c8523-c592-4c54-a7ad-442eebdd9a13	2026-02-24 13:30:43.686433+00	2856178c-806a-4f2d-90c8-63f05bddb27b	1	KG	88e270fa-841b-41b8-83f6-d5b7d03af423	Kiloan - Cuci	4000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-27 13:30:42.704
461544c7-39cf-4ef0-8d26-e567bb79d3c6	2026-02-24 13:30:43.911983+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	88e270fa-841b-41b8-83f6-d5b7d03af423	Kiloan - Cuci, Setrika	12000	f431deb8-0d2f-4b10-88c2-eacc6e840490	Kilat	6	Jam	2026-02-24 19:30:42.704
3dfacd79-d503-4e31-b35d-50533eae27c6	2026-02-24 23:20:20.4657+00	4b628038-6129-4e40-bb49-2243db2a3188	12	KG	e34ed06f-91e3-4f59-8252-77e468a02616	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-28 06:20:20.192
fdb17cc2-d5fe-4fa8-aa52-215f3e4ada10	2026-02-24 23:20:20.50754+00	4b628038-6129-4e40-bb49-2243db2a3188	12	KG	e34ed06f-91e3-4f59-8252-77e468a02616	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-02-26 06:20:20.192
0aad6a8f-6bb2-4be3-9280-ebfc8606b073	2026-02-24 23:23:50.485416+00	4b628038-6129-4e40-bb49-2243db2a3188	12	KG	67839993-8703-4488-a107-cc68c62b7f4e	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-28 06:23:50.175
317e5805-6bbb-4c6e-a1b5-4ca572f43120	2026-02-24 23:23:50.526689+00	4b628038-6129-4e40-bb49-2243db2a3188	12	KG	67839993-8703-4488-a107-cc68c62b7f4e	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-02-26 06:23:50.175
426feefe-1b1b-44c3-a9a2-b13d946377c4	2026-02-25 10:32:07.401015+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	1b1e49e7-5f90-4b59-aea7-3bae79617f46	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-28 10:32:05.52
6bd4f577-b63c-47b8-afe4-8cf6eb0aff94	2026-02-25 10:32:07.627064+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	1b1e49e7-5f90-4b59-aea7-3bae79617f46	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-02-26 10:32:05.52
0396d959-3df6-4911-bd40-bb49f323790a	2026-02-25 10:32:07.846901+00	2856178c-806a-4f2d-90c8-63f05bddb27b	1	KG	1b1e49e7-5f90-4b59-aea7-3bae79617f46	Kiloan - Cuci	4000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-02-28 10:32:05.52
4e18765d-9412-4313-8096-a844af91ed7e	2026-02-25 10:32:08.06539+00	2856178c-806a-4f2d-90c8-63f05bddb27b	3.6	KG	1b1e49e7-5f90-4b59-aea7-3bae79617f46	Kiloan - Cuci	6000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-02-26 10:32:05.52
d07e5c12-51fc-4868-9bc7-f9848a3d1391	2026-02-27 23:52:12.498493+00	ea54276c-3bb3-4c7e-9dc8-8250222d8cf0	1	KG	a9b9f077-c256-4c99-86a9-e0c376b5f496	Kiloan - Cuci, Setrika	6000	af3c79e4-2b9d-4ea8-a86a-8861fd55dcf0	Reguler	3	Hari	2026-03-02 23:52:11.531
001be340-66b9-4878-ba4e-23afdda1b3c0	2026-02-27 23:52:12.733194+00	ea54276c-3bb3-4c7e-9dc8-8250222d8cf0	1	KG	a9b9f077-c256-4c99-86a9-e0c376b5f496	Kiloan - Cuci, Setrika	8000	25514e6f-69be-4143-aa4c-20baef759bf4	Express	1	Hari	2026-02-28 23:52:11.531
538d94fe-c917-417d-abba-db1b23149400	2026-03-09 16:51:27.032474+00	4b628038-6129-4e40-bb49-2243db2a3188	12	KG	7276fb30-d2eb-4d68-8b5d-c21434ff1f5a	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-12 23:51:26.858
91124b77-b493-4a23-96a3-7465c63511e5	2026-03-10 13:12:44.798394+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	bfa5d795-5866-4fe2-9cb2-81e83acf7b38	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-13 13:12:44.293
f47576f8-2833-4179-aa86-889103208e6d	2026-03-10 13:13:18.945512+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	19faa009-c44e-406e-a944-31b09c8f4d9a	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-13 13:13:18.022
a5dfb105-2353-49cb-a9fa-f7ca414144f9	2026-03-10 13:13:19.161553+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	19faa009-c44e-406e-a944-31b09c8f4d9a	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-03-11 13:13:18.022
2ce8be38-df74-4ac2-a8ee-1f6a21cf58c5	2026-03-10 13:26:34.681245+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	69f5d6f0-f634-4ee5-b89c-27035c44ad3a	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-13 13:26:33.719
a1745ad4-0a8b-4b68-a44c-48396fece16a	2026-03-10 13:26:34.913956+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	69f5d6f0-f634-4ee5-b89c-27035c44ad3a	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-03-11 13:26:33.719
37d3f188-2ee2-41e6-9bd2-6aec7db33d95	2026-03-10 13:44:58.592212+00	4b628038-6129-4e40-bb49-2243db2a3188	2	KG	ce77ff93-c08b-4b47-b52c-46dc875d1d83	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-13 13:44:57.666
b2f58397-9d77-48f2-822b-e56a7b7a7acd	2026-03-10 13:44:58.812383+00	4b628038-6129-4e40-bb49-2243db2a3188	3	KG	ce77ff93-c08b-4b47-b52c-46dc875d1d83	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-03-11 13:44:57.666
fbee5754-5daf-41aa-a446-e6f0f5c21e97	2026-03-10 23:04:43.733245+00	0b4aa7fc-fcbc-4adc-8cec-0a8ee4adb70a	1	PCS	b2a26589-e8b7-4b95-9621-52743d5660b5	Jas	30000	f431deb8-0d2f-4b10-88c2-eacc6e840490	Kilat	6	Jam	2026-03-11 05:04:43.191
6a2d0411-0da5-4089-9b73-66a31d7d07cc	2026-03-10 23:06:47.857055+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	ec6d86a0-8605-4401-b820-51d9b474a264	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-13 23:06:46.859
fc8bcb08-018a-47ca-9ef0-26e1cb37c014	2026-03-10 23:06:48.094491+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	ec6d86a0-8605-4401-b820-51d9b474a264	Kiloan - Cuci, Setrika	8000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-03-11 23:06:46.859
a8efae8c-b825-4a0e-856a-e1b6f273776b	2026-03-11 17:39:17.525233+00	4b628038-6129-4e40-bb49-2243db2a3188	12	KG	d4e5158d-4190-4a50-b087-7cec89d76659	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-15 00:39:17.351
b5646803-a0b3-4e5b-a753-006be3526272	2026-03-11 17:39:57.76494+00	4b628038-6129-4e40-bb49-2243db2a3188	12	KG	4137dfaa-4c90-41c9-a14b-5c503ade6c68	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-15 00:39:57.477
cb91bf22-3ec1-409f-890f-19100f5c1334	2026-03-11 18:00:45.144441+00	4b628038-6129-4e40-bb49-2243db2a3188	12	KG	b38a3f30-f978-4001-bfc0-1c59b4b4bae9	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-15 01:00:45.085
06719da2-1de3-45a3-a9f2-5cc78d58ac4e	2026-03-12 00:52:13.704888+00	2856178c-806a-4f2d-90c8-63f05bddb27b	1	KG	6e56c1b3-0e7e-4494-ae71-153f316b8f4f	Kiloan - Cuci	8000	f431deb8-0d2f-4b10-88c2-eacc6e840490	Kilat	6	Jam	2026-03-12 06:52:12.698
be14a057-772f-439b-b1f8-69493b004142	2026-03-12 00:52:13.929846+00	0b4aa7fc-fcbc-4adc-8cec-0a8ee4adb70a	3	PCS	6e56c1b3-0e7e-4494-ae71-153f316b8f4f	Jas	20000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-15 00:52:12.698
b046cbba-4d02-4289-a5d5-b9de669541cd	2026-03-12 02:02:17.15214+00	0b4aa7fc-fcbc-4adc-8cec-0a8ee4adb70a	1	PCS	e6a66e22-181f-478d-898a-15781e6e13ba	Jas	25000	4f12960f-3ff9-4471-a4be-9558f2cdaf24	Express	1	Hari	2026-03-13 02:02:16.149
b57ab6e2-d5cf-4d65-8c59-46674c350300	2026-03-12 02:02:17.379574+00	0b4aa7fc-fcbc-4adc-8cec-0a8ee4adb70a	1	PCS	e6a66e22-181f-478d-898a-15781e6e13ba	Jas	30000	f431deb8-0d2f-4b10-88c2-eacc6e840490	Kilat	6	Jam	2026-03-12 08:02:16.149
a9d33f32-34a1-4b6e-a2ac-fca13ff4e44b	2026-03-12 02:19:30.636905+00	4b628038-6129-4e40-bb49-2243db2a3188	1	KG	c2371b6b-b04e-4f3b-b4de-07b061659d81	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-15 02:19:29.648
0cff4942-1709-4a68-bdf1-45b8daeaf6a5	2026-03-12 02:19:30.857736+00	2856178c-806a-4f2d-90c8-63f05bddb27b	2	KG	c2371b6b-b04e-4f3b-b4de-07b061659d81	Kiloan - Cuci	8000	f431deb8-0d2f-4b10-88c2-eacc6e840490	Kilat	6	Jam	2026-03-12 08:19:29.648
53319647-23dd-4d4f-826e-73e994a11bc7	2026-03-15 21:37:24.841602+00	4b628038-6129-4e40-bb49-2243db2a3188	12	KG	2c0e2d7d-8bbb-4c45-ba27-878e05efb65a	Kiloan - Cuci, Setrika	6000	60b2f947-a1e4-4f02-93be-857b737e0aae	Reguler	3	Hari	2026-03-19 04:37:24.4
\.


--
-- Data for Name: user_referral; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_referral (id, created_at, user_id, referred_user_id, referral_reward) FROM stdin;
8f99e5fc-26ec-42ff-bfee-367d66664861	2025-07-07 16:03:07.952144+00	a7d92f73-5755-49a1-971c-5e14c1d47a31	9d659c1f-c68f-4f69-9e21-fbcf37432bab	50000
b87ad120-72d8-4ff7-8270-1d99a991cacd	2025-07-13 07:23:35.490028+00	18184643-ccb7-4f42-aa82-d423445bcf3d	9d659c1f-c68f-4f69-9e21-fbcf37432bab	50000
f4d13202-98ee-40b7-b0ea-226e9a3d9a8b	2025-07-20 03:20:14.076363+00	e128e7f5-d6b1-4895-98d0-84583540da63	9d659c1f-c68f-4f69-9e21-fbcf37432bab	50000
f0c4dc51-5508-4f5b-bd9e-6fafc20642e0	2025-11-10 14:31:41.040156+00	83731f63-30af-4793-be22-43d9b622e7d4	8db3f967-5f09-4150-a95b-010faa31a22a	50000
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (token, logo, address, password, status, oauth, created_at, id, name, email, phone_number, sequence_id, is_deleted, referral_points, referral_points_redeemed, referral_code, referral_points_ingoing) FROM stdin;
\N	\N	\N	$2b$10$tyT9KL4kBGHKLoJJfNMFX.s5TMLwYQb3EnQr9.NUKf4MafopTYWCm	verified	\N	2025-07-12 05:52:39.212722+00	92eb1485-e2f9-4e07-b56c-bc1dd8e74274	Hihhih	Hhhhh@ggjh.co	0826575447	56	f	0	0	DF7FS	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/fe4e3388-40d9-422a-8140-a5a21ab56fbb/1756563714892_1756563713893	huuuuu	$2b$10$HVgBTiM2mANtub5CNapSyugme1Rnq3d8BpOoY8E7LiW7MCqX8B4hm	verified	\N	2025-08-26 13:33:51.51853+00	fe4e3388-40d9-422a-8140-a5a21ab56fbb	rama11uuuu	Yoo@rama.com	082765728863	63	f	0	0	TR7DJ	0
\N	\N	\N	$2b$10$nw0gIvw4h7ysT1ooe/P7YeRrar33UA2tSWEiktWnWG3ZKWALlLSlO	verified	\N	2025-07-20 03:20:13.847771+00	e128e7f5-d6b1-4895-98d0-84583540da63	dskdjj	daskj@ksasj.com	08222883738	59	f	5000	45000	52YLG	0
\N	\N	\N	$2b$10$PiDf6Z1OxPrJqurmnfiiPOWW4VHv2hOs3IqYrjStHtgJCVs.ChYi.	verified	\N	2025-07-20 03:27:08.645986+00	7728b222-a096-4da0-96af-0b7934f8b9ba	Xek	Hajjah@hhs.com	0827638733	60	f	0	0	LU4MF	0
\N	\N	\N	$2b$10$uy4MBk7ffKnrP6vx1J/LruCp428rCJRYK1hypXevS9caaxyBjLnQC	verified	\N	2025-09-23 00:42:09.995293+00	f048badd-8538-46fe-bd12-ddfaa30646b2	yyyyt	yyyyy@jjsks.co	08566646464697	65	f	0	0	PCDS6	0
\N	\N	\N	$2b$10$wI8VQzr1FRQYmRgysATt4.Cj6czEX0kT8LYvC5yRjpmAHcFIW0op.	verified	\N	2025-11-10 12:03:00.497816+00	9e9f89b7-0659-411f-b06d-d75bff0eb648	Yoo4	Yoo4@rama.com	08245463315	67	f	0	0	LXCUR	0
\N	\N	\N	$2b$10$p5XN5FAIVm1.AN.xak85q.uTKjNAHjd6ORqAYAg.6pVuLgkeEowyu	verified	\N	2025-11-10 12:08:19.279948+00	b0fd6aa0-19be-4c18-96a9-5aa032cc66ff	Yoo5	Yoo5@rama.com	0821035645	68	f	0	0	QQ69Q	0
\N	\N	\N	$2b$10$aTBI50IbK4y/i1sHodBjU.P5.Tc69XLyI8lvIzoGzCDjDsO/ZWM3i	verified	\N	2025-11-12 23:20:09.431309+00	6fed4540-3689-4ee4-837d-614174568f7d	test	test@gmail.com	085664221560	70	f	0	0	ZKBJN	0
\N	\N	\N	$2b$10$Q0XYT0zVpzFCeW416JtXMO15hUohB1JbYyWKc.Ym88nscq4yvYP2u	verified	\N	2025-12-26 02:08:35.474809+00	3d57f37f-755f-42b5-a3a4-9de23314881a	Support Ipul 6	siggi128@gmai1.kr	082278422922	76	f	0	0	K2UUF	0
\N	\N	\N	$2b$10$mzvk1TlttrDRz2dZhNfXoO.CY4TBzEqUfHl/KBXRtU68LdD5u.4wS	verified	\N	2025-12-26 02:09:08.824836+00	91e55ad6-62ca-4ee9-9666-0d283a4e5af0	Support Ipul 6	rosann524@baobaosport.com	082278422922	77	f	0	0	LKKKZ	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/20a1b60b-2c45-4533-a02e-ad9d4545b860/1766761652760_payment_proof.jpg	\N	$2b$10$M1bfdqEH8loifYg4k2jicOZGxqi.Wmx6hS7O/Epe8HOa5nDtn.5d2	verified	\N	2025-12-26 02:01:08.906459+00	20a1b60b-2c45-4533-a02e-ad9d4545b860	Laundry Melati	duano@hieuclone.com	082278422922	75	f	0	0	NLK2K	0
\N	\N	\N	$2b$10$fy01fz/S8ZDrVPnb/.PC7uE1iKMCFQHo1k5JSp2Y.HgYpKbhkXnZG	verified	\N	2026-02-22 12:46:23.571143+00	cf7cfef7-6850-46c2-9efc-22c28cb0922c	support	support@cucibayargo.com	082522555555	87	f	0	0	EGVSH	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/9d659c1f-c68f-4f69-9e21-fbcf37432bab/1772353334269_merchant_logo.jpg	\N	$2b$10$CyXingUqOzcA7n779wNj4.MukyzBi7f17xaQ5ivWYldtWEsvj.Sii	verified	\N	2025-05-25 13:38:01.298897+00	9d659c1f-c68f-4f69-9e21-fbcf37432bab	Support Cuy	laundryapps225@gmail.com	085664221560	35	f	300000	1495000	5EHH4	\N
\N	\N	\N	$2b$10$MIyVEcu7DPJrC.EX47uvN.7cyXc1fjrLmmPrHHNVceOXom2GeyFL2	verified	\N	2025-07-07 16:03:07.918128+00	a7d92f73-5755-49a1-971c-5e14c1d47a31	Support Ipul 6	yirewir540@iamtile.com	082278422922	54	f	5000	45000	RZHSX	0
\N	\N	\N	$2b$10$WqBigF.R0kkvXafm2R7zCux9TQWfW6ezzNmo.ekRqXayYR4MczNuW	verified	\N	2025-07-12 06:03:30.8765+00	4b9d622e-5a7e-4bc8-96fb-79b380ad130a	Rama android	Ramaandroid@jj.co	086543675897	57	f	0	0	3EYHV	0
\N	\N	\N	$2b$10$D3N30BHKX50eRh5ecmY9/.sDYqa7e6eTWQKrB4.GdIHjtgJ4oB2dK	verified	\N	2025-04-29 06:42:30.047393+00	ab309022-bcc9-4e04-8abc-d61c4afd3416	Laundry Kaleno	kaleno1409@cyluna.com	0823923883	26	f	0	0	XZJFE	0
\N	\N	\N	$2b$10$nnzA7c1Un1FvspPD/hWUK.6O6yOC/cebOqA5lwp45qr9iAIrUjB4S	pending	\N	2025-02-23 09:26:02.558933+00	cc996432-8af0-4d72-9dd8-022ee19ff6e1	renilow874	renilow874@noomlocs.com	089778777678	7	f	0	0	L93LU	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/cc3d67d9-aafd-41b4-93e6-c00b588ec078/1737796424433_1737796423602	Dan dan dan	$2b$10$HsPnonuO8RvAiA72iTF./.r/N8qZlGfFV4Zjm.1qCuc6XXHMdAZ.C	verified	\N	2025-01-25 09:09:08.726047+00	cc3d67d9-aafd-41b4-93e6-c00b588ec078	Kapsul test	kapsulnote@gmail.com	085664221560	4	f	0	0	AUMU3	0
\N	\N	\N	$2b$10$whpOqCqpcT8bvV9SFKQ0aObufJXgA7SViPmC1rlIZZGqRn943OQQC	pending	\N	2025-03-09 04:58:21.657403+00	aea1e62f-72db-4b8a-af7e-1d72bd34665b	lofij86190	lofij86190@kaiav.com	0823238273723	9	f	0	0	ZPTEZ	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/ca3cb819-ec42-4b13-883e-e3131abe9bb2/1741505691903_1741505694541	\N	$2b$10$SlW6hyoXo.drMPREWCLV3.dbrpU8TDLcI33B0iFK5IAgZeMPd/Aam	verified	\N	2025-03-04 22:29:40.957072+00	ca3cb819-ec42-4b13-883e-e3131abe9bb2	legatov573	legatov573@hartaria.com	08238237812	8	f	0	0	ZEMG9	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/99eea1df-1d39-4fae-a8ca-65e71349b34c/1737256346268_1737256344863	test	$2b$10$R6ohgIt6ni/quc/S88cDOuXn9.DV138eNwbBOOrhzAaYIRVWwLBMy	verified	\N	2024-11-20 01:34:10.127284+00	99eea1df-1d39-4fae-a8ca-65e71349b34c	Brian	wedangcode.team@gmail.com	085664221560	3	f	0	0	M422V	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/361333db-632e-44b4-9192-7f4861046172/1741575944302_1741575943500	\N	$2b$10$IOCetf5n5vDJiaP/qkgk4O/o9gBrCxiM/jrmsxdphfGV8tkl/jVXe	verified	\N	2025-02-23 07:24:50.594501+00	361333db-632e-44b4-9192-7f4861046172	Ahmad Laundry	saifulmuhammad414@gmail.com	085664221560	6	f	0	0	VS4MJ	0
\N	\N	\N	$2b$10$zkmgNUWC5NQHlQvqMWYbUuJqHsacJsI3DJeQgoNgY5DTp1h6ApDIq	verified	\N	2025-03-14 02:18:15.24087+00	6604cebe-ece2-42dd-80de-f4cd5e8fb559	Laundryku	ratecah690@excederm.com	08262662721927	10	f	0	0	VXAY6	0
\N	\N	\N	$2b$10$QqQatG0V.c88f8Jt6Van5uyWUY9CSpzfd9uUJUgzancIJuIO//I7i	verified	\N	2025-03-16 06:08:48.996932+00	85239af0-2860-4e35-9f6f-5aa79a10ceb7	Muhammad Saiful Laundry	muhammad.saiful.engineer@gmail.com	085664221560	11	f	0	0	FKJF8	0
\N	\N	\N	$2b$10$i3aUO5DD6o4agGzyv4wNcuQVICNmB.E3UfhMp5mGsyMlF17pP5cTe	verified	\N	2025-03-16 07:23:01.354273+00	b33dc683-b9ad-4eb6-8b38-53250b250cc6	sovabex736	sovabex736@isorax.com	082392382398	12	f	0	0	WYXCM	0
\N	\N	\N	$2b$10$VO6VaNeh1aEAAKrJbT9gc.wSI.qa60VsaclAVR5H8DqDB8oxXKR1C	verified	\N	2025-03-17 11:04:06.040363+00	68711dbd-970a-4517-b999-1a47df6c550e	sojot56972	sojot56972@excederm.com	08239238293	13	f	0	0	3C4UC	0
\N	\N	\N	$2b$10$d3hLj88tU/RPo4tiptS7Bu1c.DeIhYwjh/posOsv/o5WoLeuOf.my	verified	\N	2025-03-17 12:55:07.529318+00	9123b156-5e22-44b6-b7fa-a8c76a51f178	xibaf28094	xibaf28094@excederm.com	08239238293	14	f	0	0	EX9BU	0
\N	\N	\N	$2b$10$CTz5ebS8n7lUkuKE7y6giOzuB0GgLcPX7rlvWxiGHh1RXvCmbIome	verified	\N	2025-02-13 07:39:13.41812+00	d9c0bf10-e555-4a6f-afa8-ec012d641035	hotefav744	hotefav744@prorsd.com	08999918219923	5	f	0	0	ASNEH	0
\N	\N	\N	$2b$10$8elwpMgAwM0P9Utc5S3U.ehfdOjpPbSSs.Trjx10fbMt1gfwSjBES	verified	\N	2025-03-19 06:52:49.318943+00	9e80ef92-c070-4cc5-b5f3-060f347d2c87	pasax83176	pasax83176@excederm.com	082728272882	15	f	0	0	38D27	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/e9bec3fe-766c-41fe-a144-fcb73d705e95/1739673840676_1739673839911	\N	$2b$10$1NvYSpa9QyXL7ILgW9co3O7umhwr9eeWY0C0JlEb2OGGnjM4GqDay	verified	\N	2024-12-04 13:11:58.42368+00	e9bec3fe-766c-41fe-a144-fcb73d705e95	ramayy	ariframdhan831@gmail.com	0823823723	1	f	0	0	ZC2XA	0
\N	\N	\N	$2b$10$R6ohgIt6ni/quc/S88cDOuXn9.DV138eNwbBOOrhzAaYIRVWwLBMy	verified	\N	2025-03-19 14:08:06.154942+00	e231be7c-213e-4500-b437-e7ed94f468a7	modad87532	modad87532@excederm.com	0826277262887	17	f	0	0	EXQE4	0
\N	\N	\N	$2b$10$zcxJ78wL2VucS.ktppgT5.hospJ/03BwWFya9SkmZp.clqBVpSxxm	verified	\N	2025-03-23 03:13:17.169865+00	7e2288a2-3004-4784-aac2-a3c2fb4155f9	Bilan	bilan13864@amgens.com	088998898878	20	f	0	0	36J4	0
\N	\N	\N	$2b$10$z4VtY1x2KgtBznBoXuvYtOTEKrBPEsdwraGod3jUp8wNchcIk/hhK	verified	\N	2025-03-23 04:02:27.365378+00	a2eed2f1-b740-4512-8d71-368c2df49c59	Dweido	bodesaw108@evluence.com	098123712312	21	f	0	0	LNJRF	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/8ea1e721-d977-412f-86fb-17585368a773/1742859086935_1742859085572	\N	$2b$10$IYPr9A66DiWbnilT3MnhtOvDWyF1rZ2KwnMQgvY3iXOpGeOP1/3q6	verified	\N	2025-03-23 02:52:00.36805+00	8ea1e721-d977-412f-86fb-17585368a773	Emil Laundry	dewido1296@evluence.com	098766567354	19	f	0	0	G5857	0
\N	\N	\N	$2b$10$EfujU4PzBv3TYnvJIHo1QOIyPYLvZ0W6YpXkl5Cqk0wdBsEExlRFu	verified	\N	2025-04-06 02:10:21.062253+00	563694c4-3b7f-4a17-accd-f42f40131373	bocokax614	bocokax614@buides.com	0855555454444	22	f	0	0	JRFBN	0
\N	\N	\N	$2b$10$W5KUCURjv1Sa2ZmoS.749.uwwds5JyuCxlcDB5iRvgOdKSilt1vqW	verified	\N	2025-04-13 10:21:01.872611+00	e32ad1af-905e-4781-86ae-389edd96ff9d	savohox396	savohox396@clubemp.com	023822938238	23	f	0	0	CQQKT	0
\N	\N	\N	$2b$10$seBtMMHhla5o97psXYkZ..kH.NVdahHmXUTO.dPxan8zGCvINvNve	verified	\N	2025-04-27 12:44:32.091061+00	d73cfd09-e4ca-415d-880b-d5944c8a04df	gedeyit452	gedeyit452@astimei.com	086775677756	25	f	0	0	Q52TL	0
\N	\N	\N	$2b$10$aoRW/e60/yNmcKdlGdQR8OHZB.4ZKUZHybfVP5Yoof.23Xy44iBFe	verified	\N	2025-05-01 15:07:24.939961+00	8be70116-5bc2-4a51-a3b5-5001739899ae	Test IPUL	fitapoh193@exitings.com	082278422922	32	f	0	0	7MXB9	0
\N	\N	\N	$2b$10$7JeK3tPSP8JSTLYQpRjjYO8NeV7k04OS6Xqd3aixa0f38jc9NM03u	verified	\N	2025-05-04 07:08:55.70622+00	ff9c0083-6186-40e8-b24a-0801bec4e4f4	horov55909	horov55909@exitings.com	082329389128	33	f	0	0	SXH8N	0
\N	\N	\N	$2b$10$OUqlOO.HLmV5yHMtfLTGeuWioV7rS8kBdtSSqDgOKWNIzVmLs6G1q	verified	\N	2025-06-14 11:48:27.986707+00	e17e7401-b5f6-4aa9-9ee9-979ab0838ed6	Support Ipul 3	02160anfrv@xkxkud.com	082278422922	39	f	0	0	2XELT	0
\N	\N	\N	$2b$10$E0eiqauORTCxD.52Ref/tOLX8fbCQ4oNbSU5QwNbEM5iK745ELCTq	verified	\N	2025-03-19 07:03:24.266702+00	0fed73db-0c6d-4f95-a913-48b1131595fc	neronov460	neronov460@excederm.com	082627726383	16	t	0	0	FJJX8	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/490e65e1-0159-4a63-855c-b3ed8e621ef4/1747797176070_1747797174358	Yogyakarta	$2b$10$5CPSgCWZpqCKg1B6EDTcMOY2DjBe4B3GFVfgDCTQXygssYbSkTska	verified	\N	2025-05-21 03:00:56.718301+00	490e65e1-0159-4a63-855c-b3ed8e621ef4	Test Laundry	gahaje6317@betzenn.com	083727277172	34	f	0	0	XENGV	0
\N	\N	\N	$2b$10$cQI9n7EEnozVyfm69nbVnemZIRw2AjyBQYjOVe91L65guHuIlOra.	verified	\N	2025-06-14 11:30:20.321707+00	5f892fcb-c56a-4059-ba66-e581e45e3a67	Support Ipul 2	1p9ikdbyrd@daouse.com	082278422922	37	f	0	0	GFMJ	0
\N	\N	\N	$2b$10$7r9dZ7hSHcanWt1ddv1SqevNsko/g3Rh0O0KMwVruaN5Cw2q/oVbu	verified	\N	2025-06-14 11:46:02.093954+00	6b4e38d3-935d-4600-b1d7-68d1e4ad081a	Support Ipul 2	ym1qyh7dih@xkxkud.com	082278422922	38	f	0	0	9QDKS	0
\N	\N	\N	$2b$10$DfWQPbcylc34y8BWKkI2NufbkFGA..n3Dw4A.82BxITk8XwVmqBfy	verified	\N	2025-06-14 11:49:25.237842+00	3cf34541-51de-42f8-9c16-5b95020d9fff	Support Ipul 3	4zqyy925l7@qejjyl.com	082278422922	40	f	0	0	NTUEN	0
\N	\N	\N	$2b$10$/2efJ.M04mUY2JcdtI2BfOqEordsLUbb9DTld.jtF1RLFGPwbO6xi	verified	\N	2025-08-05 14:27:20.434205+00	d9453749-87fb-469d-a93a-22a577b0e98b	temesow115	temesow115@nicext.com	0822103592882	61	f	0	0	TW3SU	0
\N	\N	\N	$2b$10$98X465VnBzWxbW9052Uq5OKeUobVshtZtAynntVIjSvbWhc4jSueO	verified	\N	2025-03-19 22:04:23.8924+00	530de47b-18ce-4200-865f-fece556044c2	Test Laundry	gebawam259@dmener.com	085664221560	18	t	0	0	PT3D	0
\N	\N	\N	$2b$10$4bvgeszdGHtoWVM8uT8ej.ctkCZE.SORqVxobvThroahl97Wzwyn6	verified	\N	2025-06-14 11:16:09.242292+00	704b9e26-e5ce-4f92-9b5d-ded4eecace01	Support Ipul	usl778vozn@mkzaso.com	082278422922	36	t	0	0	C7NWY	0
\N	\N	\N	$2b$10$IAM73hO7J.Zlml9UXLbHwuzfVMeIu1dE6yeZ6LO240OZmeH7i7qxe	verified	\N	2025-06-15 03:16:51.796191+00	b6af38d2-b42f-4376-8cbf-5ce4a9f6ec60	Brian	hih0xwwxhu@qacmjeq.com	0458375242	41	f	0	0	RL96W	0
\N	\N	\N	$2b$10$0GoTJVV68b4dQGvyROfUFuaOsLWSswMNyCeO6zWm0ud1ffNSkhRlu	verified	\N	2025-06-15 03:18:59.247849+00	97a25dd0-0f0e-4aa6-a7cd-8b2177e36444	Support Ipul 6	lvt5i9akwo@ibolinva.com	082278422922	42	f	0	0	7NN8N	0
\N	\N	\N	$2b$10$J4Nd9Z.16u9LN7wGSGhhtuI0rsIF1DNV0zRg9ZEcFJr3M8MsYVf.e	verified	\N	2025-06-15 03:20:20.814336+00	ddc18a20-f5e5-48d3-a94d-9febac756a86	Support Ipul 5	rlzkui3ztm@bltiwd.com	0458375242	43	f	0	0	NPNZV	0
\N	\N	\N	$2b$10$TJxe0kstqZKkvn7J02sRG.9V5vvy1YLn9fDTSGXFG//Cl2DsRf3Hq	verified	\N	2025-06-15 03:26:35.603054+00	8bd96235-350d-4f6f-9489-3f80122e1c77	sdfs	wanase4095@forcrack.com	123123123213	44	f	0	0	6XUQB	0
\N	\N	\N	$2b$10$sAMBdueqB.aBX9XteBe9SeU73e852Qb23BaqxqUHdr7lQXCTu4BcC	verified	\N	2025-06-15 12:21:33.519224+00	eea90897-1470-4ff5-a32d-cabb71375c9e	lipexef585	lipexef585@nab4.com	08566554665	45	f	0	0	6UUPE	0
\N	\N	\N	$2b$10$TqpEnKmMwVFDoJqydMr60OO8bRLd0eMdhAtzr8WuZtRcjyuUhppu6	verified	\N	2025-06-15 12:59:19.579119+00	1ad21901-807d-4aa4-80d4-640876d4faab	,a,sdm,a	aksdj@kja.as	0855555555	46	f	0	0	YPXTX	0
\N	\N	\N	$2b$10$kAO4LxTEKjEP15y5/gFFl.BnH8.ae606rZFdn2vUSkPuWrlnncvJC	verified	\N	2025-06-15 13:01:07.435262+00	ca12daac-dbf3-4c1f-86d9-ed35a1407b96	sqslas	sasak@las.as	08666565566	47	f	0	0	MNUZJ	0
\N	\N	\N	$2b$10$zZGK30wQLz6yXj8u/U/p2eP4xXkF2ShzCXXAFZdjvOYDyQjEMMwT6	verified	\N	2025-06-16 14:43:24.100769+00	b54508fb-9003-4919-93e3-096d0b87f9a8	Support Ipul 6	vhavey@tinyios.com	082278422922	48	f	0	0	79FZW	0
\N	\N	\N	$2b$10$zoOmuCNJmaEKFvZq2aX6ceiUKuK8BqjokvBXpt98MWuRmsDRowu8W	verified	\N	2025-07-12 05:40:21.841172+00	cb9a86a1-2f1d-4780-a271-4e04fefa17dc	Hhehs 1111	ghhsj@gmi.com	087765435678	55	f	0	0	VCEFN	0
\N	\N	\N	$2b$10$uFpEvnNH/IHGapZA7Brgx.OUrQSurz7cZuIEy.BxQ.ejlgNhVKrV.	verified	\N	2025-12-29 14:00:57.700885+00	9673cd3f-9374-4ecc-a569-d750f3f3ff34	Yoo10	Yoo10@rama.com	0856494885	80	f	0	0	VMZ4T	0
\N	\N	\N	$2b$10$ni/EWiR62Iksa9vuTMpRWO0evn97nMu/4LAtJr9YK6PpnWwdBkzbe	verified	\N	2025-07-13 07:23:35.264001+00	18184643-ccb7-4f42-aa82-d423445bcf3d	Support Ipul 7	gimav89728@simerm.com	082278422922	58	f	5000	45000	AQTPT	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/9219a1c6-4a23-48a9-b2e2-a1088c4cd99e/1755786365748_1755786364461	\N	$2b$10$MS8WJdAqEnXM1YMZGd8vEuGsWKLTxhMeQtQhUeIN0CGJ2uyz4lpD6	verified	\N	2025-08-12 13:48:12.839869+00	9219a1c6-4a23-48a9-b2e2-a1088c4cd99e	Test rama	Test@rama.com	082993977383	62	f	0	0	WXDEJ	0
\N	\N	\N	$2b$10$gshDekxY5BJP6IEmO.nf8eoqU3.dRf0UzD5pzKhq5GtVLfpcoVFf2	verified	\N	2025-09-09 15:02:16.541161+00	7aefc064-bbad-40cc-b31e-645c90c9116c	Rama	Yoo2@rama.com	082647377648	64	f	0	0	9WZ94	0
\N	\N	\N	$2b$10$c77FcW67ltw4oQIT4/SGDuNy6rj6m1pG40jMWMcZ4Kkcv48r9ieia	verified	\N	2025-12-29 14:02:51.465394+00	ba472db5-f09a-48c3-b6c9-e3233acfc46f	Yoo11	Yoo11@rama.com	0856494885	81	f	0	0	WU3CC	0
\N	\N	\N	$2b$10$W2KszZO8CXahcsdR1p8V6Oz83GWd0XfX7Tq16yz./eb9oSpMbTPR2	verified	\N	2026-02-21 07:39:46.73938+00	6e56ab91-182b-4f44-b226-d1f0dc289423	testlik	tesgsgst@gmail.com	085664221560	83	f	0	0	R8AEQ	0
\N	\N	\N	$2b$10$Q0.sgZJwlL2OVUA/zi05ouHrS5SHupnJRpFNRQ8Fn4jYUll2Vh3z.	verified	\N	2025-11-10 14:31:40.812512+00	83731f63-30af-4793-be22-43d9b622e7d4	wawan 	jajal@gmail.com	085664221560	69	f	5000	45000	JA4R7	0
\N	\N	\N	$2b$10$RUhEICxJWqUtrdpjOVuSVOgyXTAA6BocvUiEy9d2XjEzHg6ToIscu	verified	\N	2025-12-24 11:58:56.074534+00	acb4da41-865e-40d9-a330-070c0a2b88c8	test2	test2@rama.com	082256454896	71	f	0	0	TUYVG	0
\N	\N	\N	$2b$10$smie9rc0cpNm4Domnt92XuAvREGcCcZ7txl84WazPewucMZ7Gy21S	verified	\N	2025-12-24 12:05:44.940148+00	fd3b45ee-c2fe-4d36-95dd-e6e7566e4494	test3	test3@rama.com	0824346786	72	f	0	0	UZFSK	0
\N	\N	\N	$2b$10$LGHoRVMIg67hQzNm.gIOVO8jLhgmQciggKTGpoLa9TaQBeBpjPOuS	verified	\N	2025-12-24 12:09:39.000708+00	dd479ee9-79bd-4642-b46a-d87f97446a78	test4	test4@rama.com	0854616181	73	f	0	0	FNLDJ	0
\N	\N	\N	$2b$10$8wboRoGmsdH81R0fBYHiu.a0lFMi9vhs5Q8QY.6ZVl8xeTai05wjS	verified	\N	2025-12-24 12:15:32.984263+00	9be660ec-3b6c-41ec-9d3b-0819437a7d1e	test5	test5@rama.com	08646643454	74	f	0	0	29ZM5	0
\N	\N	\N	$2b$10$of2/vUfsEQTbTlhXw2AvrO8JTIA0rKSaoSXFEVo./uy.JxU.B.7y6	verified	\N	2026-02-21 07:40:45.812489+00	579c0264-e4bf-4cac-881d-2d3aa5fff59d	testlik	tesgsfggst@gmail.com	085664221560	84	f	0	0	ZVLAP	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/8db3f967-5f09-4150-a95b-010faa31a22a/1766752977886_payment_proof.jpg	\N	$2b$10$udLOvuPNrixCcttGJxnVjuhxN13vVpT.n9BLl3IIExPX62K31CJTu	verified	\N	2025-09-23 12:04:44.280669+00	8db3f967-5f09-4150-a95b-010faa31a22a	Toko Laundry Saya	Yoo3@rama.com	0852364666666	66	f	50000	0	YL4WZ	0
\N	\N	\N	$2b$10$vawxV63Unn0B643y8LNiHeNReRvaAC4IzB9cB5cpEXtbw1mrV6mtu	verified	\N	2025-12-29 13:47:31.196357+00	40b66b3d-ca74-414c-8879-3318ab49ce38	Yooo8	Yoo8@rama.com	0856181666664	78	f	0	0	VS8GE	0
\N	\N	\N	$2b$10$iyk1/FrqzwDE8QjPuXxSUOvzR1UFdmqPEnwhIXQ.Sa5lSg6Ut4jri	verified	\N	2025-12-29 13:56:28.878079+00	d74b18af-dd09-42f1-97c6-1286fb33604c	Yoo9	Yoo9@rama.com	0856494885	79	f	0	0	GHJDT	0
\N	\N	\N	$2b$10$oVgRSvqWI5sFkoxWjXMAp.0Fo8JQbj0raIcMD9xwnXAY6/GSB1T3u	verified	\N	2026-02-21 07:41:12.408281+00	8d468ffc-f533-48ba-8c6b-285d63647a99	testlik	ipul@gmail.com	085664221560	85	f	0	0	ADYB4	0
\N	\N	\N	$2b$10$heoxbJ6oKHUVpk6JCMRSk.h7y67JDD3uOdyIbLqhpQwfGds3PMZji	verified	\N	2026-02-21 07:41:28.027074+00	65e7caf4-1316-49da-a3b9-3b7f8fef3955	testlik	ipul2@gmail.com	085664221560	86	f	0	0	8TKK5	0
\N	\N	\N	$2b$10$n/U6Kiku415Gxrv1Czqp7ugNF81O8zyJgsxs8GQZzpFT8HO1.5.ie	verified	\N	2026-02-27 22:29:07.349457+00	4b843f69-8041-4846-8af4-872de4c5c41e	support2r	support2@cucibayargo.com	08255555555	88	f	0	0	LQAVA	0
\N	https://zqmjnaaammivfblxwbnl.supabase.co/storage/v1/object/public/logos/logos/3d54010f-5655-4c05-bed1-4984d5347c93/1772353831630_merchant_logo.jpg	\N	$2b$10$qZwo2T23I/CqhcXrJ0LrUurXl.Hpq1OSZTVmOAcnuu9AMmxMvV.iK	verified	\N	2025-12-29 14:04:56.605218+00	3d54010f-5655-4c05-bed1-4984d5347c93	Yoo12	Yoo12@rama.com	08233215466	82	f	0	0	PEFVR	0
\.


--
-- Data for Name: users_signup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users_signup (name, email, phone_number, created_at, token, status, user_id, subscription_plan, id) FROM stdin;
jonson	fitapoh193@exitings.com	08566421560	2025-05-01 15:07:20.472763+00	19981e3262fd2a6288f399e1d878f33b68ad1fa5a56d188b309849826ec78c7b	\N	\N	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	8fded5d9-ab3f-4d05-9241-3e5e379a7d08
jonson	fitapoh193@exitings.com	08566421560	2025-05-01 14:42:20.136178+00	22134a8f11a342c7689af2b4884a940dfb60dd198e488a3c8899222c440172a3	signed	8be70116-5bc2-4a51-a3b5-5001739899ae	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	8941efa1-faa8-4667-99d8-6e969c46536e
horov55909	horov55909@exitings.com	082329389128	2025-05-04 07:06:22.613265+00	d956300d2a8749d4ab6d09f3cab6d370df79050fb835435655f70da76ec00b8c	signed	ff9c0083-6186-40e8-b24a-0801bec4e4f4	eae03b60-99e9-49da-9878-4006c2f2c7df	e541e6e9-5f9b-4c4f-869b-7232a9a5b15a
laskasl	lsaksjd@kjas.sa	0823293372	2025-05-04 22:18:19.581333+00	83208664bac80c0ac0d7d50b00d02a37892125890260b65caf62c9b742532ae7	\N	\N	ccaa362b-d1d1-4c07-aad2-b3566d2020f4	e75e809c-bd52-487a-9a72-c748c1821ef4
Test	gahaje6317@betzenn.com	083727277172	2025-05-21 03:00:01.977409+00	62258a32d91072fc007b9c2f44564f4181aa2c3cca4a454f077f396a34f2c637	signed	490e65e1-0159-4a63-855c-b3ed8e621ef4	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	b2f12059-450b-4f61-b15c-b24a89c6aea4
Support	laundryapps225@gmail.com	085664221560	2025-05-25 13:37:09.740292+00	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImxhdW5kcnlhcHBzMjI1QGdtYWlsLmNvbSIsImlhdCI6MTc0ODE4MDIyOX0.q2Omi2HDE-ndp9ETNmVDgn-sURmqyZbbZbAhig7xYTY	signed	9d659c1f-c68f-4f69-9e21-fbcf37432bab	dd16e63d-dfef-4a16-b75c-7779f40e7f1c	7688060d-be01-4fff-9b1f-41c27fdf6812
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2024-07-19 13:46:06
20211116045059	2024-07-19 13:46:06
20211116050929	2024-07-19 13:46:06
20211116051442	2024-07-19 13:46:06
20211116212300	2024-07-19 13:46:06
20211116213355	2024-07-19 13:46:06
20211116213934	2024-07-19 13:46:06
20211116214523	2024-07-19 13:46:06
20211122062447	2024-07-19 13:46:06
20211124070109	2024-07-19 13:46:06
20211202204204	2024-07-19 13:46:06
20211202204605	2024-07-19 13:46:06
20211210212804	2024-07-19 13:46:06
20211228014915	2024-07-19 13:46:06
20220107221237	2024-07-19 13:46:06
20220228202821	2024-07-19 13:46:06
20220312004840	2024-07-19 13:46:06
20220603231003	2024-07-19 13:46:06
20220603232444	2024-07-19 13:46:07
20220615214548	2024-07-19 13:46:07
20220712093339	2024-07-19 13:46:07
20220908172859	2024-07-19 13:46:07
20220916233421	2024-07-19 13:46:07
20230119133233	2024-07-19 13:46:07
20230128025114	2024-07-19 13:46:07
20230128025212	2024-07-19 13:46:07
20230227211149	2024-07-19 13:46:07
20230228184745	2024-07-19 13:46:07
20230308225145	2024-07-19 13:46:07
20230328144023	2024-07-19 13:46:07
20231018144023	2024-07-19 13:46:07
20231204144023	2024-07-19 13:46:07
20231204144024	2024-07-19 13:46:07
20231204144025	2024-07-19 13:46:07
20240108234812	2024-07-19 13:46:07
20240109165339	2024-07-19 13:46:07
20240227174441	2024-07-19 13:46:07
20240311171622	2024-07-19 13:46:07
20240321100241	2024-07-19 13:46:07
20240401105812	2024-07-19 13:46:07
20240418121054	2024-07-19 13:46:07
20240523004032	2024-07-19 13:46:07
20240618124746	2024-07-19 13:46:07
20240801235015	2024-08-08 15:14:52
20240805133720	2024-08-08 15:14:52
20240827160934	2024-09-07 16:01:44
20240919163303	2024-11-14 16:14:12
20240919163305	2024-11-14 16:14:12
20241019105805	2024-11-14 16:14:12
20241030150047	2024-11-14 16:14:13
20241108114728	2024-11-14 16:14:13
20241121104152	2024-11-23 14:28:54
20241130184212	2024-12-03 01:20:06
20241220035512	2025-01-11 15:30:48
20241220123912	2025-01-11 15:30:48
20241224161212	2025-01-11 15:30:48
20250107150512	2025-01-11 15:30:48
20250110162412	2025-01-11 15:30:48
20250123174212	2025-01-26 12:29:21
20250128220012	2025-02-08 08:52:29
20250506224012	2025-06-13 14:49:26
20250523164012	2025-06-13 14:49:26
20250714121412	2025-10-05 13:38:56
20250905041441	2025-10-05 13:38:57
20251103001201	2025-11-12 23:12:58
20251120212548	2026-02-04 13:07:58
20251120215549	2026-02-04 13:07:59
20260218120000	2026-02-27 14:20:29
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
logos	logos	\N	2024-08-17 19:43:12.458703+00	2024-08-17 19:43:12.458703+00	t	f	\N	\N	\N	STANDARD
app_transactions	app_transactions	\N	2024-11-30 16:12:29.641451+00	2024-11-30 16:12:29.641451+00	t	f	\N	\N	\N	STANDARD
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2024-07-19 13:41:58.917139
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2024-07-19 13:41:58.977239
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2024-07-19 13:41:59.114517
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2024-07-19 13:41:59.195104
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2024-07-19 13:41:59.21701
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2024-07-19 13:41:59.343334
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2024-07-19 13:41:59.400507
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2024-07-19 13:41:59.539974
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2024-07-19 13:41:59.60432
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2024-07-19 13:41:59.668623
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2024-07-19 13:41:59.732883
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2024-07-19 13:41:59.822039
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2024-07-19 13:41:59.880343
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2024-07-19 13:41:59.936815
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2024-07-19 13:41:59.993817
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2024-07-19 13:42:00.056887
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2024-07-19 13:42:00.121956
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2024-07-19 13:42:00.142108
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2024-07-19 13:42:00.226443
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2024-07-19 13:42:00.26198
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2024-07-19 13:42:00.325163
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2024-08-22 16:30:26.913176
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-08-26 18:53:37.62229
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2025-11-17 17:00:19.209196
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2025-11-17 17:00:19.26528
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2025-11-17 17:00:19.482303
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2025-11-17 17:00:19.494858
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2025-12-19 17:00:16.600287
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2024-07-19 13:41:59.036836
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2024-07-19 13:41:59.281105
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2024-07-19 13:41:59.416054
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2024-07-19 13:41:59.476411
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2025-08-26 18:53:33.21175
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2025-08-26 18:53:33.721045
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2025-08-26 18:53:34.008877
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2025-08-26 18:53:34.207018
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2025-08-26 18:53:34.305284
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2025-08-26 18:53:36.00845
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2025-08-26 18:53:36.315843
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2025-08-26 18:53:36.609266
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2025-08-26 18:53:36.702963
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2025-08-26 18:53:36.817227
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2025-08-26 18:53:37.50282
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2025-08-26 18:53:38.103395
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2025-09-23 17:00:20.721294
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2025-09-23 17:00:20.826214
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2025-09-25 17:00:16.130897
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2025-09-25 17:00:16.257952
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2025-09-25 17:00:16.300206
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2025-11-17 17:00:19.500987
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-02-10 14:54:40.618992
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-02-10 14:54:40.804807
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-02-10 14:54:40.806436
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-02-10 14:54:41.00129
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-02-10 14:54:41.005391
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-02-10 14:54:41.006923
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-02-10 14:54:41.025947
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
a2450fd2-301d-4a79-8c27-605bf10a6568	app_transactions	invoice/1765897052813_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2025-12-16 14:57:34.566418+00	2025-12-16 14:57:34.566418+00	2025-12-16 14:57:34.566418+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-12-16T14:57:35.000Z", "contentLength": 3894979, "httpStatusCode": 200}	f9053a54-f792-44fe-a159-71559eb1013b	\N	{}
a553de34-82c4-4099-99d7-03763dcffedc	logos	logos/fe4e3388-40d9-422a-8140-a5a21ab56fbb/1756563714892_1756563713893	\N	2025-08-30 14:21:56.12183+00	2025-08-30 14:21:58.933993+00	2025-08-30 14:21:56.12183+00	{"eTag": "\\"b22d4f23a85c95100869dcdfedacd210\\"", "size": 60536, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-08-30T14:21:59.000Z", "contentLength": 60536, "httpStatusCode": 200}	2db92db8-8125-408e-bc47-2a84dbfb8a27	\N	{}
c9d54005-029e-4118-afb3-ab3947397608	app_transactions	invoice/1772207074742_payment_proof.jpg	\N	2026-02-27 15:44:36.020407+00	2026-02-27 15:44:36.020407+00	2026-02-27 15:44:36.020407+00	{"eTag": "\\"b24ccd17b98c28692b50e5063d78b2c8\\"", "size": 118184, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T15:44:37.000Z", "contentLength": 118184, "httpStatusCode": 200}	ac765d62-c353-44ff-87c9-c51936090603	\N	{}
388b330c-4154-4a37-b1b0-3df0a009e936	logos	2.png	\N	2025-10-17 15:03:20.668669+00	2025-10-17 15:03:20.668669+00	2025-10-17 15:03:20.668669+00	{"eTag": "\\"d80f3443208aef7d5afbdebb841baf54-1\\"", "size": 44723, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-10-17T15:03:21.000Z", "contentLength": 44723, "httpStatusCode": 200}	c1fff013-9f01-4170-b142-6df25b5f35a9	\N	\N
180bcf66-12bc-4ed9-95b4-d9701363f914	app_transactions	invoice/1766498143791_payment_proof.jpg	\N	2025-12-23 13:55:44.920205+00	2025-12-23 13:55:44.920205+00	2025-12-23 13:55:44.920205+00	{"eTag": "\\"cde76e8cae963d9f7470f58647a2654a\\"", "size": 91867, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-12-23T13:55:45.000Z", "contentLength": 91867, "httpStatusCode": 200}	48fb31c4-6680-4b80-9165-4396824db62d	\N	{}
6f33beb3-223d-4626-bd08-d27f6450d643	logos	2-cropped.png	\N	2025-10-17 15:06:57.024538+00	2025-10-17 15:06:57.024538+00	2025-10-17 15:06:57.024538+00	{"eTag": "\\"0204a64c4d4581ee176b28d926dd4941-1\\"", "size": 41255, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-10-17T15:06:56.000Z", "contentLength": 41255, "httpStatusCode": 200}	b3b55fe8-e0b8-4dad-8a5d-5a840688ae92	\N	\N
051af5c2-4585-4f97-8a1c-ca5655163f4b	app_transactions	invoice/.emptyFolderPlaceholder	\N	2025-12-14 13:29:31.77827+00	2025-12-14 13:29:31.77827+00	2025-12-14 13:29:31.77827+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2025-12-14T13:29:31.818Z", "contentLength": 0, "httpStatusCode": 200}	861260b6-463f-43ed-854c-c3643e96dc10	\N	{}
bac6ebb9-ced9-49e8-89e2-ed85a5d9b963	app_transactions	invoice/1772351996374_payment_proof.jpg	\N	2026-03-01 07:59:57.462668+00	2026-03-01 07:59:57.462668+00	2026-03-01 07:59:57.462668+00	{"eTag": "\\"9dad0f59004c6613373f7ae76542717f\\"", "size": 110364, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T07:59:58.000Z", "contentLength": 110364, "httpStatusCode": 200}	fbcf21ba-b402-48ed-9d34-6cf19d10706e	\N	{}
d0846422-a3a0-40bb-b04a-7237e6df03fb	logos	logos/9d659c1f-c68f-4f69-9e21-fbcf37432bab/1772352168366_2026-02-02_14-10.png	\N	2026-03-01 08:02:50.010046+00	2026-03-01 08:03:05.62702+00	2026-03-01 08:02:50.010046+00	{"eTag": "\\"6d73d7133d2a34aa7509722f834db92a\\"", "size": 552532, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:03:06.000Z", "contentLength": 552532, "httpStatusCode": 200}	49982b83-e8e3-4a85-a256-dc9e457e0157	\N	{}
37b0b0a8-15b1-480c-83df-7ef511fcc031	app_transactions	invoice/1772352649709_payment_proof.jpg	\N	2026-03-01 08:10:51.445464+00	2026-03-01 08:10:51.445464+00	2026-03-01 08:10:51.445464+00	{"eTag": "\\"5700820a375e22aedafb53e4749235ca\\"", "size": 1773634, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:10:52.000Z", "contentLength": 1773634, "httpStatusCode": 200}	23d1bcc6-87f8-4bae-8874-6ec339181f00	\N	{}
e1a06f1f-b5b9-495c-8134-11154f2b584f	app_transactions	invoice/1772352753210_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-03-01 08:12:35.028141+00	2026-03-01 08:12:35.028141+00	2026-03-01 08:12:35.028141+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:12:35.000Z", "contentLength": 3894979, "httpStatusCode": 200}	a536813b-b0b6-476a-bdd0-c6f550c29351	\N	{}
1758a28f-b617-480b-90f4-4898e48af3ff	app_transactions	invoice/1772352816865_2026-01-25_20-20.png	\N	2026-03-01 08:13:37.629635+00	2026-03-01 08:13:37.629635+00	2026-03-01 08:13:37.629635+00	{"eTag": "\\"09ba87907ea8364b9b5caf7126d01889\\"", "size": 173108, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:13:38.000Z", "contentLength": 173108, "httpStatusCode": 200}	ea46b9ac-fb9a-4a39-b4c7-55f4ba9287c5	\N	{}
3548062c-5963-4ed7-9351-c62462b900ae	app_transactions	invoice/1772352840366_2026-01-25_20-20.png	\N	2026-03-01 08:14:01.260873+00	2026-03-01 08:14:01.260873+00	2026-03-01 08:14:01.260873+00	{"eTag": "\\"09ba87907ea8364b9b5caf7126d01889\\"", "size": 173108, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:14:02.000Z", "contentLength": 173108, "httpStatusCode": 200}	b9c39dd9-05a6-40e5-b386-197fe6a107e2	\N	{}
a666fb7f-0aac-4046-b4aa-626975772f92	app_transactions	invoice/1772353047758_2026-01-25_20-20.png	\N	2026-03-01 08:17:28.560278+00	2026-03-01 08:17:28.560278+00	2026-03-01 08:17:28.560278+00	{"eTag": "\\"09ba87907ea8364b9b5caf7126d01889\\"", "size": 173108, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:17:29.000Z", "contentLength": 173108, "httpStatusCode": 200}	114e8c35-ee78-40e0-803f-63278ef6666b	\N	{}
9ce34275-5eaa-4c24-aea1-1adb34c22f97	app_transactions	invoice/1772353133807_2026-01-25_20-20.png	\N	2026-03-01 08:18:54.427693+00	2026-03-01 08:18:54.427693+00	2026-03-01 08:18:54.427693+00	{"eTag": "\\"09ba87907ea8364b9b5caf7126d01889\\"", "size": 173108, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:18:55.000Z", "contentLength": 173108, "httpStatusCode": 200}	2fea746f-296d-4ec7-9525-bf4a898021a8	\N	{}
274e7449-c4eb-45a3-9820-1ccbe4cd8118	app_transactions	invoice/1772353215099_2026-01-25_20-20.png	\N	2026-03-01 08:20:15.694111+00	2026-03-01 08:20:15.694111+00	2026-03-01 08:20:15.694111+00	{"eTag": "\\"09ba87907ea8364b9b5caf7126d01889\\"", "size": 173108, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:20:16.000Z", "contentLength": 173108, "httpStatusCode": 200}	301bd657-ec3e-45d2-b23c-7545cef736c6	\N	{}
5c1f55cf-6f8c-4daa-933f-4ac37a15c7ba	app_transactions	invoice/1766714792754_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2025-12-26 02:06:39.394318+00	2025-12-26 02:06:39.394318+00	2025-12-26 02:06:39.394318+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-12-26T02:06:40.000Z", "contentLength": 3894979, "httpStatusCode": 200}	c11a02aa-3efa-41af-8239-d1fc413573fc	\N	{}
a5ee93e8-d03b-4968-bf78-a850739941e7	logos	logos/9d659c1f-c68f-4f69-9e21-fbcf37432bab/1772353334269_merchant_logo.jpg	\N	2026-03-01 08:22:15.242137+00	2026-03-01 08:22:21.408604+00	2026-03-01 08:22:15.242137+00	{"eTag": "\\"a772e2b943182258dcbfebd39b3cc8cf\\"", "size": 533708, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:22:22.000Z", "contentLength": 533708, "httpStatusCode": 200}	ac669431-5b82-4a96-b7aa-223f74aedfca	\N	{}
1b1f9547-50d2-4138-89b1-152308595538	logos	logos/3d54010f-5655-4c05-bed1-4984d5347c93/1772353831630_merchant_logo.jpg	\N	2026-03-01 08:30:32.67482+00	2026-03-01 08:30:44.244894+00	2026-03-01 08:30:32.67482+00	{"eTag": "\\"ed458de206aaae0fcc3789c82fc0461e\\"", "size": 30526, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:30:45.000Z", "contentLength": 30526, "httpStatusCode": 200}	8672a2aa-d6d0-4a0c-ab0c-9c305671eb17	\N	{}
4111c2d9-bf03-4287-9507-d860c98299f3	logos	logos/842d73bc-2184-4840-afca-8ed30227f178/1726371330048_1726371329074	\N	2024-09-15 03:35:31.468981+00	2025-08-26 18:53:34.215257+00	2024-09-15 03:35:31.468981+00	{"eTag": "\\"1bd90e27f48b71ddf82f39389984e0bf\\"", "size": 1019, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-15T03:35:42.000Z", "contentLength": 1019, "httpStatusCode": 200}	8d0cc0dd-7068-4e80-87bb-591e0cd8e6a5	\N	{}
6d08d164-a81a-4077-8174-77ed11fe6ba8	logos	logos/ca3cb819-ec42-4b13-883e-e3131abe9bb2/1741505691903_1741505694541	\N	2025-03-09 07:34:53.20871+00	2025-08-26 18:53:34.215257+00	2025-03-09 07:34:53.20871+00	{"eTag": "\\"2bc944c49ef993620106cef2b0d7c7d4\\"", "size": 91032, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-03-09T07:34:59.000Z", "contentLength": 91032, "httpStatusCode": 200}	8ede0d93-56c2-40ae-85d7-0f17d6923e47	\N	{}
a29f8300-7be2-4936-ad53-c4b3f24c26a5	logos	logos/cc3d67d9-aafd-41b4-93e6-c00b588ec078/1737796424433_1737796423602	\N	2025-01-25 09:13:46.131528+00	2025-08-26 18:53:34.215257+00	2025-01-25 09:13:46.131528+00	{"eTag": "\\"2b305b4b2c0a45832c1c0423858e98ad\\"", "size": 86350, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-01-25T09:13:54.000Z", "contentLength": 86350, "httpStatusCode": 200}	57e769a6-d909-4373-9a57-14e1f4dce33e	\N	{}
7e7dc56e-6c19-424f-ab0b-ed0beae934d7	app_transactions	Payment Method/dana-cucibayargo.jpg	\N	2025-11-23 14:32:32.700815+00	2025-11-23 14:32:48.863169+00	2025-11-23 14:32:32.700815+00	{"eTag": "\\"58c93cd416a505c0bc0b31bc3c58485c\\"", "size": 98681, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-11-23T14:32:49.000Z", "contentLength": 98681, "httpStatusCode": 200}	c6d1d6dc-e6c1-47cb-bf03-dbc8432fa7e5	\N	\N
bdf46088-1d07-4d5e-8b8e-252b978bc933	app_transactions	invoice/1772353935606_payment_proof.jpg	\N	2026-03-01 08:32:16.547936+00	2026-03-01 08:32:16.547936+00	2026-03-01 08:32:16.547936+00	{"eTag": "\\"729fc68b1f99e73727911dd2c5b8e9b4\\"", "size": 84828, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:32:17.000Z", "contentLength": 84828, "httpStatusCode": 200}	8a073149-3f86-4f93-94ac-81eb9ae493c8	\N	{}
f80e3ce4-f1cd-4339-acdf-e642f7df65e4	app_transactions	invoice/1772354931989_2026-01-25_20-20.png	\N	2026-03-01 08:48:52.571165+00	2026-03-01 08:48:52.571165+00	2026-03-01 08:48:52.571165+00	{"eTag": "\\"09ba87907ea8364b9b5caf7126d01889\\"", "size": 173108, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:48:53.000Z", "contentLength": 173108, "httpStatusCode": 200}	db9bcedf-bc50-414e-b4f2-e6d441a5c6c6	\N	{}
75d9a0fc-d805-4d71-b7cc-3d47a69a5051	app_transactions	invoice/1772355365209_2026-01-25_20-20.png	\N	2026-03-01 08:56:06.098949+00	2026-03-01 08:56:06.098949+00	2026-03-01 08:56:06.098949+00	{"eTag": "\\"09ba87907ea8364b9b5caf7126d01889\\"", "size": 173108, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:56:07.000Z", "contentLength": 173108, "httpStatusCode": 200}	c6a5694f-d48f-47c8-945d-d96b00be7467	\N	{}
96ea3fc3-bbff-4ec8-9a9b-29b0b3c5f11a	app_transactions	invoice/1772355552274_2026-01-25_20-20.png	\N	2026-03-01 08:59:13.575052+00	2026-03-01 08:59:13.575052+00	2026-03-01 08:59:13.575052+00	{"eTag": "\\"09ba87907ea8364b9b5caf7126d01889\\"", "size": 173108, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:59:14.000Z", "contentLength": 173108, "httpStatusCode": 200}	61060e92-6422-4749-82a5-fed944462b1b	\N	{}
7fd7048b-7237-4e9d-9e6a-8728ab0bf991	app_transactions	invoice/1772355558020_2026-01-25_20-20.png	\N	2026-03-01 08:59:18.923274+00	2026-03-01 08:59:18.923274+00	2026-03-01 08:59:18.923274+00	{"eTag": "\\"09ba87907ea8364b9b5caf7126d01889\\"", "size": 173108, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:59:19.000Z", "contentLength": 173108, "httpStatusCode": 200}	9cfbc15a-8093-409f-bc21-f0748ca9cb02	\N	{}
eea40d1e-58e3-4271-a910-7e91c16ae6b1	app_transactions	invoice/1772355591015_2026-01-25_20-20.png	\N	2026-03-01 08:59:51.422392+00	2026-03-01 08:59:51.422392+00	2026-03-01 08:59:51.422392+00	{"eTag": "\\"09ba87907ea8364b9b5caf7126d01889\\"", "size": 173108, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T08:59:52.000Z", "contentLength": 173108, "httpStatusCode": 200}	ee1ba077-c7a5-44ba-abe0-3dbf1d221611	\N	{}
79efc46c-135a-47f2-85cf-733e3ff3db41	logos	logos/8db3f967-5f09-4150-a95b-010faa31a22a/1766752977886_payment_proof.jpg	\N	2025-12-26 12:42:58.826545+00	2025-12-26 12:43:05.474175+00	2025-12-26 12:42:58.826545+00	{"eTag": "\\"1856ad5e590de0e76bd8b9a0af757734\\"", "size": 55936, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-12-26T12:43:06.000Z", "contentLength": 55936, "httpStatusCode": 200}	2eedb1e2-a579-4713-962e-0c3b6e03dffe	\N	{}
966c277c-d6f1-4bff-8fea-2b6387a0747a	app_transactions	invoice/1772407815421_payment_proof.jpg	\N	2026-03-01 23:30:16.796855+00	2026-03-01 23:30:16.796855+00	2026-03-01 23:30:16.796855+00	{"eTag": "\\"16e3139a4a28b5f12cbae3386a0b3e75\\"", "size": 159000, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-01T23:30:17.000Z", "contentLength": 159000, "httpStatusCode": 200}	2daa35ec-f66c-46bd-9ec7-a5f0199dadea	\N	{}
fe81bdd3-9df8-4ef6-9685-8f7c5092077b	logos	logos/361333db-632e-44b4-9192-7f4861046172/1741575944302_1741575943500	\N	2025-03-10 03:05:46.664941+00	2025-08-26 18:53:34.215257+00	2025-03-10 03:05:46.664941+00	{"eTag": "\\"188f4e91ea89c9a99167c9761a01d9b7\\"", "size": 57945, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-03-10T03:05:50.000Z", "contentLength": 57945, "httpStatusCode": 200}	2abff854-7a4b-4561-9d12-6fc1eaab99e0	\N	{}
c1ca957b-b784-4302-b36f-59c759444265	logos	logos/9219a1c6-4a23-48a9-b2e2-a1088c4cd99e/1755786365748_1755786364461	\N	2025-08-21 14:26:07.30844+00	2025-08-26 18:53:34.215257+00	2025-08-21 14:26:07.30844+00	{"eTag": "\\"6453d86626a2225f1ac1cfae6e5dc69e\\"", "size": 281701, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-08-21T14:26:12.000Z", "contentLength": 281701, "httpStatusCode": 200}	130a2e4b-178c-436e-850d-b52440364d51	\N	{}
87672826-3f27-4a8d-bc8c-334f4eb2762a	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726354903414_1726354903152	\N	2024-09-14 23:01:44.561202+00	2025-08-26 18:53:34.215257+00	2024-09-14 23:01:44.561202+00	{"eTag": "\\"f99014f71a83489499d8466d8e76f551\\"", "size": 697, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-14T23:01:49.000Z", "contentLength": 697, "httpStatusCode": 200}	1e5e6238-3ddf-44a9-af6a-ba576739bb9f	\N	{}
d5221f6c-0be7-490d-bb8d-1aad2af267c3	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726356650456_1726356650229	\N	2024-09-14 23:30:51.778799+00	2025-08-26 18:53:34.215257+00	2024-09-14 23:30:51.778799+00	{"eTag": "\\"c2704c280d7dc3e7022fdcfaada9a5cb\\"", "size": 1486, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-14T23:31:03.000Z", "contentLength": 1486, "httpStatusCode": 200}	236f510e-afa3-4150-becc-adf41b27625b	\N	{}
956ceee6-29d6-4588-806d-bdaacf1b20e7	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726370845395_1726370845079	\N	2024-09-15 03:27:26.683898+00	2025-08-26 18:53:34.215257+00	2024-09-15 03:27:26.683898+00	{"eTag": "\\"4b88c7c0aa870a9e70cd4160a2addf8b\\"", "size": 649, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-15T03:27:33.000Z", "contentLength": 649, "httpStatusCode": 200}	defcaec7-7ace-49f6-9654-b2c2f5ac5d88	\N	{}
29be2d6f-4284-47c7-b465-ad83e54ff5d0	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726670009739_1726670009145	\N	2024-09-18 14:33:30.275828+00	2025-08-26 18:53:34.215257+00	2024-09-18 14:33:30.275828+00	{"eTag": "\\"f22ac29d7bd832261fe9769b63507d4e\\"", "size": 79058, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-18T14:33:37.000Z", "contentLength": 79058, "httpStatusCode": 200}	ae2b264b-9544-4855-be86-22e25f4a69a3	\N	{}
e8d9e2a7-ecff-494c-8ab0-5071c02c3802	logos	logos/20a1b60b-2c45-4533-a02e-ad9d4545b860/1766761652760_payment_proof.jpg	\N	2025-12-26 15:07:34.012556+00	2025-12-26 15:07:40.784368+00	2025-12-26 15:07:34.012556+00	{"eTag": "\\"6701e8aac0df6eebef1cf24f93f14376\\"", "size": 77366, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-12-26T15:07:41.000Z", "contentLength": 77366, "httpStatusCode": 200}	47fd490b-6a5e-441a-8abb-c48c85dcd472	\N	{}
39a20e5e-b084-42ce-80aa-458e23a677de	app_transactions	invoice/1773012059294_payment_proof.jpg	\N	2026-03-08 23:21:00.657828+00	2026-03-08 23:21:00.657828+00	2026-03-08 23:21:00.657828+00	{"eTag": "\\"253ee3a48de7f3893e3928d4153fd353\\"", "size": 238749, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-08T23:21:01.000Z", "contentLength": 238749, "httpStatusCode": 200}	950ed63b-85aa-4f45-b071-5bcec2b338d7	\N	{}
1f6c385f-1e22-4d45-8176-e900061ad13e	logos	.emptyFolderPlaceholder	\N	2024-08-18 01:47:49.303989+00	2025-08-26 18:53:34.215257+00	2024-08-18 01:47:49.303989+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2024-08-18T01:47:50.000Z", "contentLength": 0, "httpStatusCode": 200}	b6c91736-1884-4777-82d1-1335c3025f54	\N	\N
be055d98-6ea8-48f6-8612-42522e6fb8a4	app_transactions	invoice/1767016996717_payment_proof.jpg	\N	2025-12-29 14:03:18.280222+00	2025-12-29 14:03:18.280222+00	2025-12-29 14:03:18.280222+00	{"eTag": "\\"5d71cd4fcc9270d575c4a03da38f52b3\\"", "size": 262142, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-12-29T14:03:19.000Z", "contentLength": 262142, "httpStatusCode": 200}	9e427867-2adb-4fc1-8e11-0f9c58487e0d	\N	{}
2b8e6197-f39b-4ebd-8fae-d498d0acb6da	app_transactions	invoice/1767017122400_payment_proof.jpg	\N	2025-12-29 14:05:23.977268+00	2025-12-29 14:05:23.977268+00	2025-12-29 14:05:23.977268+00	{"eTag": "\\"4595d61ea4b6ae9b775aed0ca3a3f93a\\"", "size": 268563, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-12-29T14:05:24.000Z", "contentLength": 268563, "httpStatusCode": 200}	d8c204f1-e6a1-49ac-8e32-9716293c1991	\N	{}
6aceac89-a938-4817-905a-847fd960d8e0	logos	logos/0e115f35-f398-4880-a896-0b8cb9d2fc74/1728821765395_1728821764756	\N	2024-10-13 12:16:06.88047+00	2025-08-26 18:53:34.215257+00	2024-10-13 12:16:06.88047+00	{"eTag": "\\"96382901c2b78356ec1ef2a796d64016\\"", "size": 9007, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-10-13T12:16:13.000Z", "contentLength": 9007, "httpStatusCode": 200}	d58ea850-62f6-4ec7-9f7b-514e7811dc59	\N	{}
55482cfb-c169-4e4b-a1c1-7606044d114b	logos	logos/490e65e1-0159-4a63-855c-b3ed8e621ef4/1747797176070_1747797174358	\N	2025-05-21 03:12:57.403656+00	2025-08-26 18:53:34.215257+00	2025-05-21 03:12:57.403656+00	{"eTag": "\\"4c9855da0a8410125cf90061dec79ed8\\"", "size": 113013, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-05-21T03:13:01.000Z", "contentLength": 113013, "httpStatusCode": 200}	037e1c04-017f-4801-b1a4-4633b09850e1	\N	{}
9c0a571f-9ace-49c9-8aed-fb43d7ce23db	logos	logos/8ea1e721-d977-412f-86fb-17585368a773/1742859086935_1742859085572	\N	2025-03-24 23:31:28.455377+00	2025-08-26 18:53:34.215257+00	2025-03-24 23:31:28.455377+00	{"eTag": "\\"e5d9a8297f13b1265de9cd29eb28bd96\\"", "size": 151857, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-03-24T23:31:34.000Z", "contentLength": 151857, "httpStatusCode": 200}	71f03f7f-84ae-4298-88b8-ed60c3bd3567	\N	{}
3d2b4a44-a586-467a-8f27-49eea8cae572	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1725374239708_image.jpeg	\N	2024-09-03 14:37:21.033287+00	2025-08-26 18:53:34.215257+00	2024-09-03 14:37:21.033287+00	{"eTag": "\\"e890432f837bd61b9c04802bd8fd4477\\"", "size": 63, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2024-09-03T14:37:57.000Z", "contentLength": 63, "httpStatusCode": 200}	f5e33e32-2acc-4e72-a124-9cf790dfb77b	\N	{}
866ce161-e3a1-4d94-8e50-7831fbdbca4f	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1725464552932_image.png	\N	2024-09-04 15:42:34.209756+00	2025-08-26 18:53:34.215257+00	2024-09-04 15:42:34.209756+00	{"eTag": "\\"88b139f28ffdc580ccc0936cadfc1cee\\"", "size": 63, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2024-09-04T15:42:48.000Z", "contentLength": 63, "httpStatusCode": 200}	5e9e2364-fce0-417b-bccd-a399c390a7ca	\N	{}
db44992d-152f-4a76-aba8-8c5eb66686cf	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1725465040121_logo-1725465039197.png	\N	2024-09-04 15:50:41.548774+00	2025-08-26 18:53:34.215257+00	2024-09-04 15:50:41.548774+00	{"eTag": "\\"114f7d8a669c283fd72f5f7d7fdbcfb9\\"", "size": 63, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2024-09-04T15:50:48.000Z", "contentLength": 63, "httpStatusCode": 200}	91cd1bd9-ddd4-4a4d-ba9d-0c8edfbdc6af	\N	{}
db4a05ca-f2a4-4b0b-bbd0-43c90f833751	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1725547152856_logo-1725547152665.png	\N	2024-09-05 14:39:13.496719+00	2025-08-26 18:53:34.215257+00	2024-09-05 14:39:13.496719+00	{"eTag": "\\"639be3bf6901ab1107145a7892b563d7\\"", "size": 63, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-09-05T14:39:18.000Z", "contentLength": 63, "httpStatusCode": 200}	63764339-e3a9-49f1-8661-d387fcfd83fc	\N	{}
90317793-081f-42d6-97d9-5a3d88b7cf36	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1725548202567_logo-1725548200116.png	\N	2024-09-05 14:56:44.005895+00	2025-08-26 18:53:34.215257+00	2024-09-05 14:56:44.005895+00	{"eTag": "\\"7eacc39636c4f89d30556a8c0039be1b\\"", "size": 63, "mimetype": "text/plain", "cacheControl": "max-age=3600", "lastModified": "2024-09-05T14:56:49.000Z", "contentLength": 63, "httpStatusCode": 200}	781ef992-8fb2-41ec-8032-09e2b0d4444f	\N	{}
f5f6ec66-36a3-4a28-9b4d-bd9b1193b138	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1725548311391_logo-1725548311086.png	\N	2024-09-05 14:58:32.719006+00	2025-08-26 18:53:34.215257+00	2024-09-05 14:58:32.719006+00	{"eTag": "\\"266dc030050ce6e9fe037daeb6b64ce0\\"", "size": 63, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-09-05T14:58:44.000Z", "contentLength": 63, "httpStatusCode": 200}	b0fed32d-26a1-4b0b-a691-c36ac0cb4dab	\N	{}
b0a06947-bdcf-49ae-9460-ff9fd94de94b	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1725548417918_logo-1725548417730.jpg	\N	2024-09-05 15:00:19.166111+00	2025-08-26 18:53:34.215257+00	2024-09-05 15:00:19.166111+00	{"eTag": "\\"5d6883a36fdd041e120ac6ffce94b42c\\"", "size": 63, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-05T15:00:24.000Z", "contentLength": 63, "httpStatusCode": 200}	99e17391-2f73-4542-acfe-bab8be2d7157	\N	{}
8b1ee52b-b21e-4ebe-a5c7-629a222f5b3b	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1725784583641_1725784581092	\N	2024-09-08 08:36:25.122549+00	2025-08-26 18:53:34.215257+00	2024-09-08 08:36:25.122549+00	{"eTag": "\\"c2704c280d7dc3e7022fdcfaada9a5cb\\"", "size": 1486, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-08T08:37:17.000Z", "contentLength": 1486, "httpStatusCode": 200}	4598256f-dc92-4d09-956a-91781a0a02c3	\N	{}
866eca45-2ce6-4c56-8dca-35afb8b6ad5a	app_transactions	invoice/1772097540714_payment_proof.jpg	\N	2026-02-26 09:19:01.815144+00	2026-02-26 09:19:01.815144+00	2026-02-26 09:19:01.815144+00	{"eTag": "\\"06d763765c560b46c92fc11ed4b436e8\\"", "size": 63125, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-26T09:19:02.000Z", "contentLength": 63125, "httpStatusCode": 200}	d64a6942-c1eb-443e-9844-f07c433a0ec7	\N	{}
257bb8c5-2c8e-42b5-b322-56f0f04d79c4	logos	logos/99eea1df-1d39-4fae-a8ca-65e71349b34c/1737256346268_1737256344863	\N	2025-01-19 03:12:27.90809+00	2025-08-26 18:53:34.215257+00	2025-01-19 03:12:27.90809+00	{"eTag": "\\"0b13d6ec1ae9eedc50e80d957ad4c9f4\\"", "size": 151605, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-01-19T03:12:32.000Z", "contentLength": 151605, "httpStatusCode": 200}	fec7c654-939e-4bfb-9c1d-7c4101078d06	\N	{}
3b74fd62-07f3-40a9-87a8-8ef0517e13af	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1725784884844_1725784882980	\N	2024-09-08 08:41:26.239877+00	2025-08-26 18:53:34.215257+00	2024-09-08 08:41:26.239877+00	{"eTag": "\\"177b355bdd2b9c9ac756c942076e603a\\"", "size": 1090, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-08T08:41:40.000Z", "contentLength": 1090, "httpStatusCode": 200}	0a686dbc-00db-4394-aeb7-21da74bbd0ad	\N	{}
500828f5-02cf-49dc-97c9-5b3a08f7ced4	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1725790623665_1725790623396	\N	2024-09-08 10:17:05.026298+00	2025-08-26 18:53:34.215257+00	2024-09-08 10:17:05.026298+00	{"eTag": "\\"f5eb80299e3f34ed9fc5e5374717cbc6\\"", "size": 1678, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-08T10:17:12.000Z", "contentLength": 1678, "httpStatusCode": 200}	75a4e55c-d48d-43e0-b43f-d98598f47b25	\N	{}
99a5f3d7-58e7-446c-85cd-74272771b067	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726371070229_1726371069484	\N	2024-09-15 03:31:11.634552+00	2025-08-26 18:53:34.215257+00	2024-09-15 03:31:11.634552+00	{"eTag": "\\"7aa8a980b78ef159c193939ffc23bdfa\\"", "size": 1001, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-15T03:31:19.000Z", "contentLength": 1001, "httpStatusCode": 200}	183f28e0-e9a3-415a-9617-a29706fd21e1	\N	{}
3c66a4d3-e62c-4f4d-8502-8cff08089529	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726372070185_1726372072032	\N	2024-09-15 03:47:52.171875+00	2025-08-26 18:53:34.215257+00	2024-09-15 03:47:52.171875+00	{"eTag": "\\"511394e4a5db74a8884d1730e50362ed\\"", "size": 814, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-15T03:48:01.000Z", "contentLength": 814, "httpStatusCode": 200}	f0222b6a-b1b3-4a68-a390-9611648c44aa	\N	{}
dc270f8a-a7c0-4aeb-a57d-a25c7777363f	logos	logos/e447e5af-3cd7-4ace-a42f-0543b2d7af2d/1723975106291_packaman.png	\N	2024-08-18 09:58:28.451901+00	2025-08-26 18:53:34.215257+00	2024-08-18 09:58:28.451901+00	{"eTag": "\\"b6be49d09e92aed23d2752a7f057bc31\\"", "size": 4035, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-08-18T10:15:18.000Z", "contentLength": 4035, "httpStatusCode": 200}	ad2a1995-3852-424b-a057-879e9b8023c7	\N	\N
b9b76a4d-5d5c-4439-b554-7e39cc966224	logos	logos/e447e5af-3cd7-4ace-a42f-0543b2d7af2d/1723975813975_packaman.png	\N	2024-08-18 10:10:15.369203+00	2025-08-26 18:53:34.215257+00	2024-08-18 10:10:15.369203+00	{"eTag": "\\"b6be49d09e92aed23d2752a7f057bc31\\"", "size": 4035, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-08-18T10:12:17.000Z", "contentLength": 4035, "httpStatusCode": 200}	dfd87cea-9382-4962-8e81-5323674d25dd	\N	\N
cbf2cd25-71d3-470d-bcd7-7d670d8bb6eb	logos	logos/e447e5af-3cd7-4ace-a42f-0543b2d7af2d/1723976217405_output.jpg	\N	2024-08-18 10:16:58.299543+00	2025-08-26 18:53:34.215257+00	2024-08-18 10:16:58.299543+00	{"eTag": "\\"88556e2bd622476d340fe670af849878\\"", "size": 98532, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-08-18T10:17:31.000Z", "contentLength": 98532, "httpStatusCode": 200}	36ad5a40-4684-4144-9897-2d249862e107	\N	\N
de6f0f9e-d891-4555-be1d-47f03801a83e	logos	logos/e4889d08-bd9e-4da0-baa1-fa5422ba8a06/1725465538630_output.jpg	\N	2024-09-04 15:59:00.769459+00	2025-08-26 18:53:34.215257+00	2024-09-04 15:59:00.769459+00	{"eTag": "\\"88556e2bd622476d340fe670af849878\\"", "size": 98532, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-09-04T16:01:00.000Z", "contentLength": 98532, "httpStatusCode": 200}	0f2bb654-ce36-457c-9cd8-88aa1bc5b989	\N	{}
f77b4ff1-16e2-4a2f-9405-6e9b277a6977	logos	logos/8db3f967-5f09-4150-a95b-010faa31a22a/1764973099336_payment_proof.jpg	\N	2025-12-05 22:18:20.646823+00	2025-12-05 22:18:31.803569+00	2025-12-05 22:18:20.646823+00	{"eTag": "\\"51bde5b0115c737e04b06976f9553792\\"", "size": 139746, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-12-05T22:18:32.000Z", "contentLength": 139746, "httpStatusCode": 200}	3e678ac9-b2ae-4252-8896-07552e950204	\N	{}
7b07f2d3-ebeb-442d-bdde-940ef07b8182	app_transactions	invoice/1772160738639_payment_proof.jpg	\N	2026-02-27 02:52:19.807398+00	2026-02-27 02:52:19.807398+00	2026-02-27 02:52:19.807398+00	{"eTag": "\\"9dad0f59004c6613373f7ae76542717f\\"", "size": 110364, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T02:52:20.000Z", "contentLength": 110364, "httpStatusCode": 200}	573b06a0-b8b2-49e5-84d6-cd1019323ff1	\N	{}
3f21870b-f710-4941-a1d6-c0ff371b02df	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726672535192_1726672533226	\N	2024-09-18 15:15:37.024525+00	2025-08-26 18:53:34.215257+00	2024-09-18 15:15:37.024525+00	{"eTag": "\\"a6923724150f029e1a9d9ae6d0fdd10b\\"", "size": 224742, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-18T15:15:45.000Z", "contentLength": 224742, "httpStatusCode": 200}	4ad9d0be-7995-4490-9d0b-cb43c15f64f4	\N	{}
6344327d-fa3a-4cc3-b24a-23775714e517	logos	logos/e4889d08-bd9e-4da0-baa1-fa5422ba8a06/1725465679080_output.jpg	\N	2024-09-04 16:01:19.589172+00	2025-08-26 18:53:34.215257+00	2024-09-04 16:01:19.589172+00	{"eTag": "\\"88556e2bd622476d340fe670af849878\\"", "size": 98532, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-09-04T16:01:35.000Z", "contentLength": 98532, "httpStatusCode": 200}	b80a8d4b-6d1e-4935-81e4-63cad328fd6b	\N	{}
ea51700b-a119-496d-87d5-c43675802e58	logos	logos/e4889d08-bd9e-4da0-baa1-fa5422ba8a06/1725465761402_output.jpg	\N	2024-09-04 16:02:42.081693+00	2025-08-26 18:53:34.215257+00	2024-09-04 16:02:42.081693+00	{"eTag": "\\"88556e2bd622476d340fe670af849878\\"", "size": 98532, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-09-04T16:03:15.000Z", "contentLength": 98532, "httpStatusCode": 200}	9e9b9f6d-fa1e-4046-8096-c5bee1e0bda4	\N	{}
23519269-065f-4595-a3d2-4e925138c78f	logos	logos/e9bec3fe-766c-41fe-a144-fcb73d705e95/1737256329334_1737256328605	\N	2025-01-19 03:12:11.023019+00	2025-08-26 18:53:34.215257+00	2025-01-19 03:12:11.023019+00	{"eTag": "\\"aa244ff3d6b0e6690d9f15a0333e0e27\\"", "size": 182496, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-01-19T03:12:19.000Z", "contentLength": 182496, "httpStatusCode": 200}	3bc08c35-4aef-482f-ab9f-796c866eb9a6	\N	{}
0be42a43-cfda-4011-b4c6-52cd694cd1da	logos	logos/e9bec3fe-766c-41fe-a144-fcb73d705e95/1738788566932_1738788566514	\N	2025-02-05 20:49:28.30821+00	2025-08-26 18:53:34.215257+00	2025-02-05 20:49:28.30821+00	{"eTag": "\\"fe842a59054834d7cb0c7202ddb7a272\\"", "size": 39108, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-02-05T20:50:05.000Z", "contentLength": 39108, "httpStatusCode": 200}	745908d0-e1d2-489a-aefb-cc0ed5fca04c	\N	{}
8a157bb6-c2dc-4685-a9dc-ea9adc49ebab	logos	logos/e9bec3fe-766c-41fe-a144-fcb73d705e95/1738793842879_1738793842137	\N	2025-02-05 22:17:24.270018+00	2025-08-26 18:53:34.215257+00	2025-02-05 22:17:24.270018+00	{"eTag": "\\"fe842a59054834d7cb0c7202ddb7a272\\"", "size": 39108, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-02-05T22:17:32.000Z", "contentLength": 39108, "httpStatusCode": 200}	b8188d5e-e558-4322-bd21-895d0a24a2d2	\N	{}
0b889839-4727-47d4-8915-d95b4bfa37f0	logos	logos/e9bec3fe-766c-41fe-a144-fcb73d705e95/1739191112338_1739191111234	\N	2025-02-10 12:38:34.267227+00	2025-08-26 18:53:34.215257+00	2025-02-10 12:38:34.267227+00	{"eTag": "\\"3831dac5e449c96b64aba719f852ad68\\"", "size": 186386, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-02-10T12:39:22.000Z", "contentLength": 186386, "httpStatusCode": 200}	345f46b3-20af-4ec0-8138-4980b8d65c82	\N	{}
83187f6a-7f3d-4573-90f4-8028919d93b3	logos	logos/e9bec3fe-766c-41fe-a144-fcb73d705e95/1739673840676_1739673839911	\N	2025-02-16 02:44:01.962407+00	2025-08-26 18:53:34.215257+00	2025-02-16 02:44:01.962407+00	{"eTag": "\\"e8949d314ea9522b65f17f1f267d3ec3\\"", "size": 37446, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-02-16T02:44:19.000Z", "contentLength": 37446, "httpStatusCode": 200}	033e1403-3962-46e4-b552-f918795086a4	\N	{}
09109c11-6cba-44ca-9f77-ab9ef3b612c2	logos	logos/8db3f967-5f09-4150-a95b-010faa31a22a/1764974520419_payment_proof.jpg	\N	2025-12-05 22:42:01.470275+00	2025-12-05 22:42:12.379759+00	2025-12-05 22:42:01.470275+00	{"eTag": "\\"d43436676a067d6a8013a5acf5e02261\\"", "size": 29161, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-12-05T22:42:13.000Z", "contentLength": 29161, "httpStatusCode": 200}	74dac637-9b16-4f56-9fe5-efa1c14087e9	\N	{}
13f933c4-a585-4eec-9232-77bbcb5211ad	app_transactions	invoice/1772202259538_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 14:24:22.093214+00	2026-02-27 14:24:22.093214+00	2026-02-27 14:24:22.093214+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T14:24:23.000Z", "contentLength": 3894979, "httpStatusCode": 200}	5cd07562-764e-4aa2-972e-69e4436536ff	\N	{}
b3a9d3cd-7039-4f3c-9d13-41d93c5fc4de	app_transactions	invoice/1772202617744_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 14:30:19.217024+00	2026-02-27 14:30:19.217024+00	2026-02-27 14:30:19.217024+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T14:30:20.000Z", "contentLength": 3894979, "httpStatusCode": 200}	249ccd95-8c72-45cf-8b2c-40791c141ce2	\N	{}
82c64220-4a3a-4093-b580-beefebeb923f	app_transactions	invoice/1772202705163_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 14:31:46.852281+00	2026-02-27 14:31:46.852281+00	2026-02-27 14:31:46.852281+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T14:31:47.000Z", "contentLength": 3894979, "httpStatusCode": 200}	e9717dab-5118-459c-9d5a-90477853e4d9	\N	{}
f1e9c415-77f5-4b2e-b77c-960dde85476e	app_transactions	invoice/1772202862331_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 14:34:23.49966+00	2026-02-27 14:34:23.49966+00	2026-02-27 14:34:23.49966+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T14:34:24.000Z", "contentLength": 3894979, "httpStatusCode": 200}	60fb37dc-c3a3-4ea2-8dcc-a69d7c004f0b	\N	{}
1cce8170-9ea1-4371-a7f3-1ceefc13f5a8	app_transactions	invoice/1772202872692_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 14:34:33.788849+00	2026-02-27 14:34:33.788849+00	2026-02-27 14:34:33.788849+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T14:34:34.000Z", "contentLength": 3894979, "httpStatusCode": 200}	db6bb3b7-c747-4165-8c1b-358b9076996e	\N	{}
b56889a6-4d34-430c-b051-a5208071ea31	app_transactions	invoice/1772202909027_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 14:35:10.042768+00	2026-02-27 14:35:10.042768+00	2026-02-27 14:35:10.042768+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T14:35:10.000Z", "contentLength": 3894979, "httpStatusCode": 200}	f9c0db86-b3d9-461e-b3e0-4b0d35c49a00	\N	{}
679dbd58-2555-4a52-ae9a-fed2e7e65e9d	app_transactions	invoice/1772203331984_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 14:42:13.537775+00	2026-02-27 14:42:13.537775+00	2026-02-27 14:42:13.537775+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T14:42:14.000Z", "contentLength": 3894979, "httpStatusCode": 200}	f26513ac-3d6f-48ca-af3c-b6d27729bbbd	\N	{}
5b8ab48b-46e1-4cea-ad42-cdb3884ccdb7	app_transactions	invoice/1772203343490_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 14:42:24.905084+00	2026-02-27 14:42:24.905084+00	2026-02-27 14:42:24.905084+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T14:42:25.000Z", "contentLength": 3894979, "httpStatusCode": 200}	1ed6d2f1-ee5f-4443-a0d8-9243305d13f6	\N	{}
c0c3a7fb-2fec-48af-8f6f-06d0b5a5e5ee	app_transactions	invoice/1772204378496_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 14:59:39.9942+00	2026-02-27 14:59:39.9942+00	2026-02-27 14:59:39.9942+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T14:59:40.000Z", "contentLength": 3894979, "httpStatusCode": 200}	935ced8b-f3d8-4d6f-85c2-470e1c15e561	\N	{}
2e09638c-cd1b-4d40-b281-3dc8c8b4ddc8	logos	logos/842d73bc-2184-4840-afca-8ed30227f178/1726972820136_1726972819308	\N	2024-09-22 02:40:21.514844+00	2025-08-26 18:53:34.215257+00	2024-09-22 02:40:21.514844+00	{"eTag": "\\"3416819d3e5657c7289d9f940beefdc5\\"", "size": 73201, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-22T02:40:29.000Z", "contentLength": 73201, "httpStatusCode": 200}	a9c41263-c62d-4378-940f-670daac27305	\N	{}
b61f934c-1762-4896-8abe-155c568b5fce	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726408421320_1726408420945	\N	2024-09-15 13:53:42.772347+00	2025-08-26 18:53:34.215257+00	2024-09-15 13:53:42.772347+00	{"eTag": "\\"004d7aec42c8befb2a75fd975268a26e\\"", "size": 37072, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-15T13:53:49.000Z", "contentLength": 37072, "httpStatusCode": 200}	082d32da-c2d4-4cd2-b862-78434f8091b1	\N	{}
7889ab3d-48c0-4495-8558-46c0a737d426	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726972729895_1726972724831	\N	2024-09-22 02:38:51.715923+00	2025-08-26 18:53:34.215257+00	2024-09-22 02:38:51.715923+00	{"eTag": "\\"cd050566c9ad088bde14a800a0a78146\\"", "size": 192938, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-22T02:39:06.000Z", "contentLength": 192938, "httpStatusCode": 200}	37d2d0cc-73ce-49f8-9817-81451b8ff0c6	\N	{}
6c18dead-e160-45d8-9cf4-9ec7805891f6	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726972912205_1726972909856	\N	2024-09-22 02:41:53.598048+00	2025-08-26 18:53:34.215257+00	2024-09-22 02:41:53.598048+00	{"eTag": "\\"295edc7aa4b941e1dee5202eb66fab8e\\"", "size": 93082, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-22T02:42:02.000Z", "contentLength": 93082, "httpStatusCode": 200}	3256279f-5f37-4650-87ca-54d7d85eaba9	\N	{}
7c031c10-3e99-4a2d-bb78-34679965f590	logos	logos/e9bec3fe-766c-41fe-a144-fcb73d705e95/1733628688525_1733628687736	\N	2024-12-08 03:31:30.076365+00	2025-08-26 18:53:34.215257+00	2024-12-08 03:31:30.076365+00	{"eTag": "\\"6c013496d63ebb44414eea8563397735\\"", "size": 87475, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-12-08T03:31:34.000Z", "contentLength": 87475, "httpStatusCode": 200}	002954fd-bc9f-43d6-97b2-0242db78127f	\N	{}
47d32fb2-1299-4011-a3ad-bdb928851770	logos	logos/e9bec3fe-766c-41fe-a144-fcb73d705e95/1733628703667_1733628702877	\N	2024-12-08 03:31:45.115953+00	2025-08-26 18:53:34.215257+00	2024-12-08 03:31:45.115953+00	{"eTag": "\\"ecd23ae383b0e061f83e62b6a15799c7\\"", "size": 84071, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-12-08T03:31:50.000Z", "contentLength": 84071, "httpStatusCode": 200}	a96d17b3-2697-418b-88bb-2ffd710361b6	\N	{}
7ea9061d-5797-4253-8871-00975ad26437	logos	logos/8db3f967-5f09-4150-a95b-010faa31a22a/1765113397227_payment_proof.jpg	\N	2025-12-07 13:16:38.475344+00	2025-12-07 13:16:45.994253+00	2025-12-07 13:16:38.475344+00	{"eTag": "\\"92820d8a1516187db71afb2ab1db618b\\"", "size": 385768, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-12-07T13:16:46.000Z", "contentLength": 385768, "httpStatusCode": 200}	c326372a-e43b-4f4b-b685-9cf7508ab462	\N	{}
bb7aaf6e-3d4d-4eee-8bee-83f3b1095836	app_transactions	invoice/1772205243860_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 15:14:06.618758+00	2026-02-27 15:14:06.618758+00	2026-02-27 15:14:06.618758+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T15:14:07.000Z", "contentLength": 3894979, "httpStatusCode": 200}	4ae02c9e-078f-4025-bc4b-d8a5fb4541ce	\N	{}
be58c687-36a6-447d-b581-3f351f2c9edb	app_transactions	invoice/1772205583757_eric-dekker-0jqI8_MRBKU-unsplash.jpg	\N	2026-02-27 15:19:45.059216+00	2026-02-27 15:19:45.059216+00	2026-02-27 15:19:45.059216+00	{"eTag": "\\"44b91ed4edbb385d1235e9a9ea2a605d\\"", "size": 3894979, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-27T15:19:45.000Z", "contentLength": 3894979, "httpStatusCode": 200}	e3c52952-3e2f-48f4-ac68-1fcad18bf27b	\N	{}
2dc9caef-c549-49a1-aaf2-7bec804c93bc	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726408705400_1726408704274	\N	2024-09-15 13:58:26.668818+00	2025-08-26 18:53:34.215257+00	2024-09-15 13:58:26.668818+00	{"eTag": "\\"579318c51e55b52c3ce728a33cb41654\\"", "size": 68937, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-15T13:58:34.000Z", "contentLength": 68937, "httpStatusCode": 200}	3b14ee54-8e53-4767-b9e8-207f9d524b57	\N	{}
09271e0c-7502-4cca-acaa-4561b0a59241	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1726408758409_1726408758179	\N	2024-09-15 13:59:18.977717+00	2025-08-26 18:53:34.215257+00	2024-09-15 13:59:18.977717+00	{"eTag": "\\"1dfb47d682626de90b2598c357312fa1\\"", "size": 2606, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-15T13:59:29.000Z", "contentLength": 2606, "httpStatusCode": 200}	b50dd9ed-dfa2-4cbc-a3e1-990b9f954283	\N	{}
8f1918b5-4aa6-424d-bbd5-53c984579e11	logos	logos/d0254557-698f-4441-9f2a-e23e6c306541/1727359444824_1727359442718	\N	2024-09-26 14:04:06.033854+00	2025-08-26 18:53:34.215257+00	2024-09-26 14:04:06.033854+00	{"eTag": "\\"f35554c7be6a77e9ec8e035b600b8517\\"", "size": 56150, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2024-09-26T14:04:35.000Z", "contentLength": 56150, "httpStatusCode": 200}	1a169a47-e52c-4b99-9c12-ecceea62f844	\N	{}
7ddae7c0-b9f8-4e6f-819f-4f505a41946e	logos	logos/e9bec3fe-766c-41fe-a144-fcb73d705e95/1737636155374_1737636154667	\N	2025-01-23 12:42:37.029832+00	2025-08-26 18:53:34.215257+00	2025-01-23 12:42:37.029832+00	{"eTag": "\\"2d072327fbf3f5f5ca537cd8e8a4d6dd\\"", "size": 64679, "mimetype": "image/jpg", "cacheControl": "max-age=3600", "lastModified": "2025-01-23T12:43:27.000Z", "contentLength": 64679, "httpStatusCode": 200}	e0f284b9-f948-450b-8a60-20e023272d02	\N	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: -
--

SELECT pg_catalog.setval('pgsodium.key_key_id_seq', 1, false);


--
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.expenses_id_seq', 12, true);


--
-- Name: invoice_sequence; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.invoice_sequence', 1, false);


--
-- Name: users_sequence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_sequence_id_seq', 88, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: app_invoices app_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_invoices
    ADD CONSTRAINT app_invoices_pkey PRIMARY KEY (id);


--
-- Name: app_plans app_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_plans
    ADD CONSTRAINT app_plans_pkey PRIMARY KEY (id);


--
-- Name: app_subscriptions app_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_subscriptions
    ADD CONSTRAINT app_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: app_transactions app_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_transactions
    ADD CONSTRAINT app_transactions_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: duration duration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.duration
    ADD CONSTRAINT duration_pkey PRIMARY KEY (id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- Name: note note_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.note
    ADD CONSTRAINT note_pkey PRIMARY KEY (id);


--
-- Name: offline_users offline_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offline_users
    ADD CONSTRAINT offline_users_pkey PRIMARY KEY (id);


--
-- Name: password_resets password_resets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT password_resets_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: printed_devices printed_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.printed_devices
    ADD CONSTRAINT printed_devices_pkey PRIMARY KEY (id);


--
-- Name: service_duration service_duration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_duration
    ADD CONSTRAINT service_duration_pkey PRIMARY KEY (id);


--
-- Name: service service_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: transaction_item transaction_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_item
    ADD CONSTRAINT transaction_item_pkey PRIMARY KEY (id);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- Name: user_referral user_referral_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_referral
    ADD CONSTRAINT user_referral_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_sequence_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_sequence_id_key UNIQUE (sequence_id);


--
-- Name: users_signup users_signup_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_signup
    ADD CONSTRAINT users_signup_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_discounts_merchant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_discounts_merchant_id ON public.discounts USING btree (merchant_id);


--
-- Name: idx_expenses_merchant_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_expenses_merchant_date ON public.expenses USING btree (merchant_id, date);


--
-- Name: idx_password_resets_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_password_resets_user_id ON public.password_resets USING btree (user_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: app_invoices trg_transfer_referral_points; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_transfer_referral_points AFTER UPDATE ON public.app_invoices FOR EACH ROW EXECUTE FUNCTION public.transfer_referral_points_on_invoice_status();


--
-- Name: user_referral trg_update_user_referral_points; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_update_user_referral_points AFTER INSERT OR DELETE OR UPDATE ON public.user_referral FOR EACH ROW EXECUTE FUNCTION public.update_user_referral_points();


--
-- Name: transaction trigger_set_order; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_set_order BEFORE INSERT ON public.transaction FOR EACH ROW EXECUTE FUNCTION public.set_order_for_transaction();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: discounts discounts_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: password_resets password_resets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT password_resets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: transaction transaction_discount_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_discount_id_fkey FOREIGN KEY (discount_id) REFERENCES public.discounts(id) ON DELETE SET NULL;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: app_invoices; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.app_invoices ENABLE ROW LEVEL SECURITY;

--
-- Name: app_plans; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.app_plans ENABLE ROW LEVEL SECURITY;

--
-- Name: app_subscriptions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.app_subscriptions ENABLE ROW LEVEL SECURITY;

--
-- Name: app_transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.app_transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: customer; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer ENABLE ROW LEVEL SECURITY;

--
-- Name: duration; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.duration ENABLE ROW LEVEL SECURITY;

--
-- Name: note; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.note ENABLE ROW LEVEL SECURITY;

--
-- Name: offline_users; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offline_users ENABLE ROW LEVEL SECURITY;

--
-- Name: payment; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.payment ENABLE ROW LEVEL SECURITY;

--
-- Name: service; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.service ENABLE ROW LEVEL SECURITY;

--
-- Name: service_duration; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.service_duration ENABLE ROW LEVEL SECURITY;

--
-- Name: transaction; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.transaction ENABLE ROW LEVEL SECURITY;

--
-- Name: transaction_item; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.transaction_item ENABLE ROW LEVEL SECURITY;

--
-- Name: user_referral; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_referral ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: users_signup; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.users_signup ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

\unrestrict Et6mYEh92Tb7tBooFUn3ETmPkvq2l6J6cDEgLRZmkBaAtPw183JcDPierSAEzNb

