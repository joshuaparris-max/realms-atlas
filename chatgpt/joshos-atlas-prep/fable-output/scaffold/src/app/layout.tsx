import './globals.css'

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <nav>
          <a href="/dashboard">Dashboard</a> | <a href="/projects">Projects</a> | <a href="/sources">Sources</a> | <a href="/actions">Actions</a> | <a href="/privacy">Privacy</a>
        </nav>
        <main>{children}</main>
      </body>
    </html>
  )
}
