require 'rails_helper'

RSpec.describe 'New Party Page' do
  describe 'Happy Path' do
    describe 'Create New Party' do
      it 'can create a party based on clicking on specific movie from search' do
        VCR.use_cassette("search_movies") do
          VCR.use_cassette("spy_kids_details") do
            user = User.create(email: 'user@example.com', password: '1234')
            friend = User.create(email: 'friend@friend.com', password: '1234')
            other_friend = User.create(email: 'other_friend@friend.com', password: '1234')
            Friendship.create(user_id: user.id, friend_id: friend.id)
            Friendship.create(user_id: user.id, friend_id: other_friend.id)
            
            visit login_path

            fill_in "email", with: user.email
            fill_in "password", with: user.password
            click_on "Log In"
            
            click_on "Discover Movies"

            fill_in "movie", with: "Untitled Spy Kids Reboot"
            click_on "Search"
          
            click_on "Untitled Spy Kids Reboot"
            
            click_on "Create a Viewing Party for Movie"

            fill_in "watch_party[time]", with: "10:00:AM"

            save_and_open_page
            expect(current_path).to eq(new_watch_party_path(user))
            expect(find_field("watch_party[date]").value).to have_content(Time.now.strftime("%Y-%m-%d"))
            expect(find_field("watch_party[duration]").value).to have_content("0")
            expect(find_field("watch_party[time]").value).to have_content("10:00:AM")
            expect(page).to have_content("Movie: Untitled Spy Kids Reboot")

            expect(page).to have_content(friend.email)
            save_and_open_page
            
            within("section#friend-#{friend.id}") do
              check "friend"
            end

            within("section#friend-#{other_friend.id}") do
              check "friend"
            end

            click_button "Create Party"

            expect(current_path).to eq(dashboard_path(user.id))
          end
        end
      end
    end
  end
  describe 'Sad Path' do

  end
end