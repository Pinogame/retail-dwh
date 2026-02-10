FROM apache/superset:latest

USER root

# Install PostgreSQL Driver into the virtual environment used by Superset
# We use --target because the global pip doesn't install into the venv by default
RUN pip install --target $(python -c "import site; print(site.getsitepackages()[0])") psycopg2-binary

# Switch back to superset user
USER superset
