local clients = vim.lsp.get_clients()
for _, c in pairs(clients) do
  print("Attached:", c.name)
end
