# Urban Strife
A tactical shooter gamemode for Garry's Mod

## Style Guidelines

- Lua syntax, not C++: ``not`` over ``!``, ``--`` over ``//`` etc.
- Indentation: 4 spaces
- ``PascalCase`` for global table var/funcs, ``flatcase`` for local var/funcs, ``SCREAMING_SNAKE_CASE`` for enums/constants
- Spaces around operators but not brackets: ``local a = 1 + func(2) * arr[3]``
- Network strings, ConVars and ConCommands are ``flatcase`` and use prefix ``us_``
  - use underscore to divide functionality/category, e.g.  ``us_damage_howmuchdamage``