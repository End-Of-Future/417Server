--比赛即将开始！请做好准备！
function c88880500.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c88880500.actg) 
	e1:SetOperation(c88880500.acop) 
	c:RegisterEffect(e1) 
end
function c88880500.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880500.thfil1,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c88880500.thfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0xd88) and c:IsType(TYPE_MONSTER)  
end 
function c88880500.thfil2(c) 
	return c:IsAbleToHand() and c:IsSetCard(0xd88) and c:IsType(TYPE_SPELL+TYPE_TRAP)  
end 
function c88880500.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88880500.thfil1,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xd88)end,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c88880500.thfil2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(88880500,0)) then 
			local sg=Duel.SelectMatchingCard(tp,c88880500.thfil2,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	end 
end 
  






