# Urban Strife
A tactical shooter gamemode for Garry's Mod

## Style Guidelines

- Lua syntax: not C++: ``not`` over ``!``, ``--`` over ``//`` etc.
- Indentation: 4 spaces
- Spaces around operators but not brackets: ``local a = 1 + func(2) * arr[3]``
- use ``self`` whenever possible, including functions in ``GAMEMODE``
- Use common variable names for recongized objects
  - ``ply`` for Player
  - ``ent`` for Entity
  - ``wep`` for Weapon
- Casing:
  - ``PascalCase`` for global table var/funcs and hook names
  - ``flatcase`` for local var/funcs
  - ``SCREAMING_SNAKE_CASE`` for enums/constants
  - ``flatcase`` for Network strings, ConVars and ConCommands; use prefix ``us_``
    - Additionally, use underscore to divide functionality/category, e.g.  ``us_damage_howmuchdamage``
  - ``snake_case`` for lua files; use ``cl_``, ``sh_``, ``sv_`` as prefix for client, shared and server files