-- Drop the first level-1 heading from the body: it becomes the page title
-- (passed via -M title=...) and is rendered by the template header instead.
-- This also keeps it out of the table of contents, so the H2 sections sit at
-- the top level naturally.
local removed = false
function Header(el)
  if not removed and el.level == 1 then
    removed = true
    return {}
  end
end
