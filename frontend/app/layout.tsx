import type { Metadata } from 'next'
import Link from 'next/link'
import './globals.css'

export const metadata: Metadata = {
  title: 'Blog App',
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
            <Link href="/">Home</Link>
          </nav>
        </header>
        <main>{children}</main>
      </body>
    </html>
  )
}