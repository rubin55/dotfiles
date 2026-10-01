;;; $DOOMDIR/after/lsp-mode.el -*- lexical-binding: t; -*-

(setq lsp-enable-suggest-server-download nil)

;; The float shows the signature; in the menu it would cover the float.
(setq lsp-completion-show-detail nil)

(setq lsp-xml-prefer-jar nil
      lsp-xml-bin-file "/usr/bin/lemminx")

(setq lsp-xml-file-associations
      [(:systemId "https://maven.apache.org/xsd/maven-4.0.0.xsd"
        :pattern "**/*.pom")])

(setq lsp-fsharp-auto-workspace-init t)

(setq lsp-pwsh-dir "/usr/share/powershell/Modules"
      lsp-pwsh-pses-script
      (concat lsp-pwsh-dir "/PowerShellEditorServices/Start-EditorServices.ps1")
      lsp-pwsh-log-path
      (expand-file-name "lsp-pwsh" temporary-file-directory))

(make-directory lsp-pwsh-log-path t)

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection '("kotlin-lsp" "--stdio"))
  :major-modes '(kotlin-mode kotlin-ts-mode)
  :priority 1
  :server-id 'kotlin-lsp))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection
                   '("roslyn-language-server" "--stdio" "--autoLoadProjects"
                     "--logLevel" "Information"))
  :major-modes '(csharp-mode csharp-ts-mode)
  :priority 1
  :server-id 'roslyn-ls))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection '("expert" "--stdio"))
  :major-modes '(elixir-mode elixir-ts-mode heex-ts-mode)
  :priority 1
  :server-id 'expert-ls))
