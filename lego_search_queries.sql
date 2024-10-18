-- 1. Find LEGO sets that have a specific word or phrase in their description
SELECT * FROM LEGO_Sets
WHERE description LIKE '%search_term%';

-- Example: Finding all sets that mention the word 'spaceship' in the description
-- SELECT * FROM LEGO_Sets WHERE description LIKE '%spaceship%';

-------------------------------------------------------------

-- 2. Sort LEGO sets by the highest piece count
SELECT * FROM LEGO_Sets
ORDER BY piece_count DESC;

-------------------------------------------------------------

-- 3. Show only sets that belong to a specific theme
SELECT * FROM LEGO_Sets
WHERE theme = 'theme_name';

-- Example: Show all sets that belong to the 'Star Wars' theme
-- SELECT * FROM LEGO_Sets WHERE theme = 'Star Wars';

-------------------------------------------------------------

-- 4. Paginate the list of LEGO sets, returning 4 sets at a time without repeating
SELECT * FROM LEGO_Sets
ORDER BY id
LIMIT 4 OFFSET 0;  -- Change OFFSET to paginate: 0 for page 1, 4 for page 2, etc.
