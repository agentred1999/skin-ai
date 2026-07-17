'use client';

import Link from 'next/link';

export default function Home() {
  return (
    <div className="min-h-screen bg-[#f8f7f4] text-black font-light">
      <nav className="fixed top-0 w-full bg-[#f8f7f4]/90 backdrop-blur border-b border-black/10 z-50">
        <div className="max-w-6xl mx-auto px-8 py-6 flex justify-between">
          <div className="text-2xl tracking-tighter">SKINSTRIC</div>
          <div className="text-xs uppercase tracking-widest pt-1">INTRO</div>
        </div>
      </nav>

      <div className="h-screen flex items-center justify-center relative">
        <div className="text-center">
          <h1 className="text-[140px] leading-none tracking-[-6px] font-light mb-6">
            Sophisticated<br />skincare
          </h1>
          <p className="text-2xl text-gray-600 max-w-md mx-auto mb-16">
            Skinstric developed an A.I. that creates a highly-personalized routine tailored to what your skin needs.
          </p>

          <div className="flex gap-8 justify-center">
            <Link href="/testing" className="group border border-black px-12 py-6 text-sm uppercase tracking-widest hover:bg-black hover:text-white transition-all flex items-center gap-3">
              DISCOVER A.I. <span className="text-3xl group-hover:translate-x-2 transition">→</span>
            </Link>
            <Link href="/testing" className="group border border-black px-12 py-6 text-sm uppercase tracking-widest hover:bg-black hover:text-white transition-all flex items-center gap-3">
              TAKE TEST <span className="text-3xl group-hover:translate-x-2 transition">→</span>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
