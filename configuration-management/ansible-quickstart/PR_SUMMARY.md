# Fix ansible-lint violations and improve playbook structure

## Changes
- Fixed 25 ansible-lint violations in ansible-quickstart directory
- Created proper `playbook.yml` with playbook-level elements (hosts, vars_files, become, handlers)
- Converted task files to proper task format (removed playbook declarations)
- Added FQCN for all ansible modules (`ansible.builtin.*`)
- Fixed YAML formatting (indentation, trailing spaces, newlines)
- Updated boolean comparisons (`is true/false` instead of `== true/false`)
- Added `changed_when` declarations for command/shell tasks
- Fixed relative path usage in templates
- Added proper task names and handlers

## Usage
Run with: `ansible-playbook -i hosts playbook.yml`

## Verification
All files now pass ansible-lint with production profile (0 failures, 0 warnings).