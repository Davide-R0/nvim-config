local M = {}

-- Manteniamo lo stato dei job per garantire il tracking dei PID
M.server_job_id = nil
M.watch_enabled = false
M.augroup = vim.api.nvim_create_augroup("OcpVscodePreview", { clear = true })

-- Comando 1: Gestione del Server
function M.toggle_server()
  if M.server_job_id then
    -- Se il server è attivo, lo terminiamo usando il suo job_id specifico
    vim.fn.jobstop(M.server_job_id)
    M.server_job_id = nil
    vim.notify("ocp_vscode server stopped.", vim.log.levels.INFO)
  else
    -- Avvio del server in modalità detached per non bloccare l'interfaccia
    M.server_job_id = vim.fn.jobstart({ "python3", "-m", "ocp_vscode" }, {
      detach = true,
      on_exit = function(_, code, _)
        M.server_job_id = nil
        -- 143 corrisponde a SIGTERM, terminazione standard. Altri codici indicano crash.
        if code ~= 0 and code ~= 143 then
          vim.notify("ocp_vscode server crashed (Exit code: " .. code .. ")", vim.log.levels.ERROR)
        end
      end
    })

    if M.server_job_id > 0 then
      local pid = vim.fn.jobpid(M.server_job_id)
      vim.notify("ocp_vscode server started [PID: " .. pid .. "]", vim.log.levels.INFO)
    else
      vim.notify("Failed to start ocp_vscode server.", vim.log.levels.ERROR)
    end
  end
end

-- Comando 2: Gestione del Watching Nativo
function M.toggle_watch()
  M.watch_enabled = not M.watch_enabled

  if M.watch_enabled then
    vim.notify("OCP Preview: Watch enabled. Script will run on save.", vim.log.levels.INFO)

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = M.augroup,
      pattern = "*.py",
      callback = function(opts)
        if not M.watch_enabled then return end

        -- Esegue il file Python asincronamente per aggiornare l'anteprima
        vim.fn.jobstart({ "python3", opts.match }, {
          on_stderr = function(_, data)
            local err = table.concat(data, "\n")
            -- Logga gli errori solo se la stringa non è vuota
            if err:match("%S") then
              vim.notify("build123d Error:\n" .. err, vim.log.levels.ERROR)
            end
          end,
        })
      end,
      desc = "Esegue lo script build123d corrente al salvataggio"
    })
  else
    vim.notify("OCP Preview: Watch disabled.", vim.log.levels.INFO)
    vim.api.nvim_clear_autocmds({ group = M.augroup, pattern = "*.py" })
  end
end

-- Hook di Sicurezza: Terminazione automatica del server alla chiusura di Neovim
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("OcpVscodeCleanup", { clear = true }),
  callback = function()
    if M.server_job_id then
      vim.fn.jobstop(M.server_job_id)
    end
  end,
  desc = "Uccide il processo del server ocp_vscode all'uscita da Neovim"
})

-- Esportazione dei comandi utente
function M.setup()
  vim.api.nvim_create_user_command("OcpServerToggle", M.toggle_server, {
    desc = "Avvia/Arresta il server ocp_vscode in background"
  })
  vim.api.nvim_create_user_command("OcpWatchToggle", M.toggle_watch, {
    desc = "Abilita/Disabilita l'esecuzione automatica del file Python al salvataggio"
  })
end

return M
