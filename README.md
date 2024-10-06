## Notes
- Start the lab
    - Overall, run this command
      ```commandline
      sh ./manage_docker.sh --config=shioaji --action=up --env=local
      ```
      
    - pure Jupyter notebook
      ```commandline
      docker compose -f ./config/jupyter/env/local/docker-compose.yaml up -d
      ```
      
    - Shioaji Jupyter notebook
      ```commandline
      docker compose -f ./config/shioaji/env/local/docker-compose.yaml up -d
      ```
      and run the command to show the token
      ```commandline
      jupyter notebook list
      ```
      
- Shut down the lab
    - Overall, run this command
      ```commandline
      sh ./manage_docker.sh --config=shioaji --action=down --env=local
      ```
    - pure Jupyter notebook
      ```commandline
      docker compose -f ./config/jupyter/env/local/docker-compose.yaml down
      ```
    - Shioaji Jupyter notebook
      ```commandline
      docker compose -f ./config/shioaji/env/local/docker-compose.yaml down
      ```

## References

- [Jupyter Lab Documentation](https://jupyterlab.readthedocs.io/en/latest/)
- [Jupyter Lab in Docker Container](https://docs.docker.com/guides/use-case/jupyter/)