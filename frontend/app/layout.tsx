import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Docker App',
  description: 'A simple blog application built with Next.js and Rails',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
        <header>
          <nav>
            <a href="/">Home</a>
            <a href="/posts">Posts</a>
            <a href="/users">Utilisateurs</a>
          </nav>
        </header>
        <main>{children}</main>
      </body>
    </html>
  )
}