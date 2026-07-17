import type { Metadata } from "next";
import "./globals.css";
import ConsoleTools from "./console-tools";

export const metadata: Metadata = {
  title: "Skinstric | Your AI Skin Analysis",
  description:
    "Skinstric developed an A.I. that creates a highly-personalized routine tailored to what your skin needs.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        <ConsoleTools />
        {children}
      </body>
    </html>
  );
}
