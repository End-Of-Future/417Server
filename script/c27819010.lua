--圣光女神的呼换
function c27819010.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,27819010+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c27819010.actg) 
	e1:SetOperation(c27819010.acop) 
	c:RegisterEffect(e1)
end 
c27819010.SetCard_XXLight=true 
function c27819010.thfil(c) 
	return c:IsLevelBelow(4) and c.SetCard_XXLight and c:IsAbleToHand() 
end 
function c27819010.spfil(c,e,tp) 
	return c:IsLevelBelow(4) and c.SetCard_XXLight and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function c27819010.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(c27819010.thfil,tp,LOCATION_DECK,0,1,nil) 
	local b2=Duel.IsExistingMatchingCard(c27819010.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	if chk==0 then return b1 or b2 end 
	local op=0 
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(27819010,0),aux.Stringid(27819010,1)) 
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(27819010,0)) 
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(27819010,1))+1  
	end 
	e:SetLabel(op) 
	if op==0 then 
	e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==1 then 
	e:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end 
end 
function c27819010.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local op=e:GetLabel() 
	local g1=Duel.GetMatchingGroup(c27819010.thfil,tp,LOCATION_DECK,0,nil) 
	local g2=Duel.GetMatchingGroup(c27819010.spfil,tp,LOCATION_HAND,0,nil,e,tp)
	if op==0 and g1:GetCount()>0 then 
	local sg=g1:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	elseif op==1 and g2:GetCount()>0 then 
	local sg=g2:Select(tp,1,1,nil)  
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end 





