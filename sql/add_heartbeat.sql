DO $$DECLARE r record;
BEGIN
	BEGIN
		ALTER TABLE queue_classic_jobs ADD COLUMN updated_at timestamptz;
	EXCEPTION
		WHEN duplicate_column THEN RAISE NOTICE 'column updated_at already exists in queue_classic_jobs.';
	END;
END$$;

DO $$DECLARE r record;
BEGIN
  BEGIN
    ALTER TABLE queue_classic_jobs ADD COLUMN locked_by uuid;
  EXCEPTION
    WHEN duplicate_column THEN RAISE NOTICE 'column locked_by already exists in queue_classic_jobs.';
  END;
END$$;
