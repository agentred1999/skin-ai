"use client";

import { useEffect } from "react";

declare global {
  interface Window {
    copyCode: () => void;
  }
}

export default function ConsoleTools() {
  useEffect(() => {
    window.copyCode = () => {
      const html = document.documentElement.outerHTML;
      navigator.clipboard
        .writeText(html)
        .then(() => {
          console.log(
            "%cPage HTML copied to clipboard!",
            "color: #1a1a1a; font-weight: bold; font-size: 13px;"
          );
        })
        .catch((err) => {
          console.error("Failed to copy:", err);
        });
    };

    console.log(
      "%cTip: run copyCode() in this console to copy the page's HTML to your clipboard.",
      "color: #6a6a6a; font-size: 11px;"
    );
  }, []);

  return null;
}
