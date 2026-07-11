    </main>

    <!-- Footer -->
    <footer class="glass-panel border-t border-slate-800 py-6 mt-12 bg-darkblue-900/60 text-slate-400 text-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row items-center justify-between space-y-4 md:space-y-0">
            
            <!-- Branding -->
            <div class="flex items-center space-x-2">
                <i class="fa-solid fa-graduation-cap text-indigo-500"></i>
                <span class="font-semibold text-slate-300">ApexExam Online Examination System</span>
            </div>
            
            <!-- Links / Info -->
            <div class="flex items-center space-x-6 text-xs">
                <span>Designed for Apache Tomcat & MySQL</span>
                <span class="text-slate-600">|</span>
                <span>© <%= java.time.Year.now().getValue() %> ApexExam. All rights reserved.</span>
            </div>
        </div>
    </footer>

    <!-- Hamburger menu control script -->
    <script>
        const btn = document.getElementById('mobile-menu-btn');
        const menu = document.getElementById('mobile-menu');

        if (btn && menu) {
            btn.addEventListener('click', () => {
                menu.classList.toggle('hidden');
                const expanded = btn.getAttribute('aria-expanded') === 'true' || false;
                btn.setAttribute('aria-expanded', !expanded);
                
                // Toggle Icon
                const icon = btn.querySelector('i');
                if(icon.classList.contains('fa-bars')) {
                    icon.classList.remove('fa-bars');
                    icon.classList.add('fa-xmark');
                } else {
                    icon.classList.remove('fa-xmark');
                    icon.classList.add('fa-bars');
                }
            });
        }
    </script>
</body>
</html>
