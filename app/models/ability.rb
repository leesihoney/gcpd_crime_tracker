class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.role? :commish
      can :manage, :all
    elsif user.role? :chief
      can :manage, Investigation
      can :manage, InvestigationNote
      can :manage, CrimeInvestigation
      can :manage, Criminal
      can :manage, Suspect
      can :manage, Assignment
      can :read, Unit
      can :update, Unit do |unit|  
        unit.id == user.unit_id
      end
      can :manage, Officer do |officer|  
        officer.unit_id == user.unit_id
      end
      can :read, User do |u|
        u.id == user.id
      end
      can :update, User do |u|
        u.id == user.id
      end
    elsif user.role? :officer
      can :read, Investigation
      can :new, Investigation
      can :create, Investigation
      can :update, Investigation do |investigation|
        user.officer.investigations.include?(investigation)
      end
      can :manage, InvestigationNote
      can :read, Assignment
      can :read, Crime
      can :manage, CrimeInvestigation
      can :manage, Criminal
      can :manage, Suspect
      can :read, Officer do |officer|
        officer.id == user.officer.id
      end
      can :update, Officer do |officer|
        officer.id == user.officer.id
      end
      can :index, Unit
      can :show, Unit do |unit|
        unit.id == user.officer.unit_id
      end
    
    else
      can :read, Crime
    end






    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
