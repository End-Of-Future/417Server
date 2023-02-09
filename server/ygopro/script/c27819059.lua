--五王的意志
function c27819059.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27819059+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c27819059.cost)
	e1:SetTarget(c27819059.target)
	e1:SetOperation(c27819059.activate) 
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c27819059.actcon)
	c:RegisterEffect(e2) 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetCountLimit(1,17819059) 
	e3:SetTarget(c27819059.thtg) 
	e3:SetOperation(c27819059.thop) 
	c:RegisterEffect(e3) 
end
c27819059.SetCard_fiveking=true
function c27819059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c27819059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,27819059,0,TYPES_NORMAL_TRAP_MONSTER,0,0,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c27819059.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,27819059,0,TYPES_NORMAL_TRAP_MONSTER,0,0,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function c27819059.filter(c)
	return c:IsFaceup() and c.SetCard_fiveking
end
function c27819059.actcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c27819059.filter,c:GetControler(),LOCATION_MZONE,0,1,nil) 
end 
function c27819059.thfil(c) 
	return c:IsAbleToHand() and c:IsCode(27819057)  
end 
function c27819059.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819059.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)==0 end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c27819059.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27819059.thfil,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end 





